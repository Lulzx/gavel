"""V1-V5: the invariants a task in the bank has to satisfy (SPEC.md 5.5).

A task is a reward function. These are the checks that it is the reward
function it claims to be -- that its reference proves what the laws say, that
it cannot be satisfied by a submission that proves nothing, and that the
latency it imposes is one a training loop can afford.

The distinction that matters throughout: a **problem** is a defect in the task
and fails validation. A **warning** is something that could not be *measured*
-- a corpus that is not built, a rate nobody has calibrated. Warnings exist so
that a half-built pipeline reports "not yet known" instead of the much worse
"fine", and ``--strict`` is what CI uses once "not yet known" is no longer an
acceptable answer.

The review check at the end of the file is the one warning about something
*known* rather than unmeasured, and its docstring argues the case.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any

from .check import CheckConfig, check_submission
from .degenerate import corpus, unmodelled
from .laws import parse_imports, split_top_level
from .runner import run_check, select_backend
from .tasks import (LAWS_FILE, PRELUDE_FILE, PROOF_FILE, SOLUTION_FILE, Task,
                    cleanup, prepare_workdir)
from .toolchain import Toolchain
from .verdict import TIER_COMPLETE, TIER_NO_CHECK

# V4: a reference slower than this makes an episode too expensive to sample.
DEFAULT_BUDGET_MS = 2000

# A tier at or above this needs a named reviewer rather than the author's own
# reading: the laws can pin more than a person can check by eye. Below it the
# author's reading is the review, and an absent record is not a gap.
REVIEW_TIER = 3

# V5: what a task's own immutable files may import.
IMMUTABLE_IMPORTS = frozenset({
    "Base", f"./{LAWS_FILE}", f"./{PRELUDE_FILE}", f"./{SOLUTION_FILE}",
})


@dataclass
class TaskReport:
    task_id: str
    tier: int
    laws: tuple[str, ...]
    hash: str
    problems: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    reference_ms: int = 0            # the slowest single checker run
    reference_total_ms: int = 0      # every run the verdict needed
    checked: list[str] = field(default_factory=list)
    mutant_tiers: list[int] = field(default_factory=list)
    mutant_strong: list[tuple[str, int]] = field(default_factory=list)
    mutant_kills: dict[str, int] = field(default_factory=dict)
    zero_shot_solve_rate: float | None = None
    review: str = "none-needed"

    @property
    def valid(self) -> bool:
        return not self.problems

    def to_json(self) -> dict[str, Any]:
        return {
            "task_id": self.task_id,
            "tier": self.tier,
            "valid": self.valid,
            "review": self.review,
            "problems": list(self.problems),
            "warnings": list(self.warnings),
            "reference_ms": self.reference_ms,
            "reference_total_ms": self.reference_total_ms,
            "laws": list(self.laws),
            "hash": self.hash,
            "checked": list(self.checked),
            "mutant_tiers": list(self.mutant_tiers),
            "mutant_strong": [name for name, _ in self.mutant_strong],
            "mutant_kills": dict(self.mutant_kills),
            "zero_shot_solve_rate": self.zero_shot_solve_rate,
        }


def validate_task(task: Task, toolchain: Toolchain, *,
                  budget_ms: int = DEFAULT_BUDGET_MS,
                  strict: bool = False,
                  config: CheckConfig | None = None) -> TaskReport:
    """Run every invariant against one task.

    ``strict`` promotes warnings to problems, which is what CI wants once the
    corpora exist: "unchecked" and "checked and fine" must not look alike in a
    green build.
    """
    config = config or CheckConfig()
    report = TaskReport(task_id=task.task_id, tier=task.tier, laws=tuple(task.laws),
                        hash=task.hash,
                        zero_shot_solve_rate=task.meta.get("zero_shot_solve_rate"))

    _posed(task, report)
    _law_references(task, report)
    _prelude_compiles(task, toolchain, config, report)
    _v1_reference(task, toolchain, config, report, budget_ms)
    _v2_mutants(task, toolchain, config, report)
    _v3_degenerate(task, toolchain, config, report)
    _v5_immutable_files(task, report)
    _v4_latency(report, budget_ms)
    _review_state(task, report)

    # Not an invariant so much as a missing measurement: M0's exit criterion is
    # stated as a solve rate, and a task nobody has calibrated is a task whose
    # difficulty is assumed. tools/calibrate.py --write-meta fills this in.
    if report.zero_shot_solve_rate is None:
        report.warnings.append("calibration: no zero_shot_solve_rate recorded")

    if strict:
        report.problems.extend(report.warnings)
        report.warnings = []
    return report


# --- review: a judgement the pipeline must not be able to write ----------------

def review_state(meta: dict[str, Any], tier: int) -> str:
    """What a task's review record actually attests to.

    One of ``none-needed`` (below ``REVIEW_TIER``), ``unreviewed``,
    ``current``, or ``stale``.

    ``current`` and not ``approved``: all this function witnesses is that a
    record exists and attests to the laws the task ships. It cannot witness who
    wrote one, and the pipeline *can* write one, so naming the state after the
    judgement would put the same word on a forged record and a genuine one --
    which is the defect Fact 27 is about, one layer up.

    A review is recorded against the hashes ``tools/publish.py`` derived from
    ``LAWS.bend`` and ``prelude.bend``, so it covers the immutable files as they
    were when it was made. Editing either one leaves the record in place and
    pointing at laws that are no longer shipped -- which is the state this
    function exists to name, because *nothing in the pipeline noticed it*.
    Three tasks in the bank were in it at once: two of them repaired in the same
    day their record was written, one of those by the session that then went on
    to cite the record as evidence.

    The comparison is to ``meta["hashes"]`` and not to ``Task.hash``: the former
    is the pair of source hashes the review was taken over, the latter folds in
    ``solution.bend`` as well and is a string, so it can only ever disagree.

    ``stale`` is a warning and not a problem, which is the one place this check
    departs from "a problem is a defect, a warning is a missing measurement".
    Two reasons, and the second is the decisive one. A review record is not part
    of the reward function, which is what ``problems`` are about. And the
    validator can see that a record is *about other laws*; it cannot see who
    wrote it. So failing on ``stale`` would hard-fail three tasks while passing
    the eight records that match their laws and are just as forged -- a
    validator that endorses the worse defect and refuses the milder one. The
    check is worth having because nothing else noticed when a ``LAWS.bend``
    edit invalidated a record, and it is worth having as a warning, whose
    ``--strict`` promotion is the honest statement: it fails the moment review
    is a thing the bank actually has.
    """
    review = meta.get("reviewed")
    if not isinstance(review, dict) or not review.get("by"):
        return "unreviewed" if tier >= REVIEW_TIER else "none-needed"
    return "current" if review.get("hashes") == meta.get("hashes") else "stale"


def _review_state(task: Task, report: TaskReport) -> None:
    report.review = review_state(task.meta, task.tier)
    if report.review == "stale":
        report.warnings.append(
            f"review: {task.meta['reviewed'].get('by')!r} is recorded against "
            f"hashes that no longer match {LAWS_FILE} or {PRELUDE_FILE}, so the "
            f"record attests to laws this task does not ship")
    elif report.review == "unreviewed":
        report.warnings.append(
            f"review: tier {task.tier} carries no review record -- the laws "
            f"have not been read by a named reviewer")


# --- posed: the task is a problem before it is a reward function ---------------

def _posed(task: Task, report: TaskReport) -> None:
    """Not one of V1-V5, and checked first because it is more basic than any of
    them: a task whose prompt is missing is still a perfectly good reward
    function, and a policy is still shown nothing.

    ``prompt.md`` is read with ``is_file()`` and falls back to the empty string,
    which is what makes this silent -- every other invariant passes, and the
    only symptom is a model asked to prove a theorem it was never told.
    """
    if not task.prompt.strip():
        report.problems.append(
            "posed: prompt.md is missing or empty, so the policy is shown no "
            "problem statement")


def _law_references(task: Task, report: TaskReport) -> None:
    """A law may cite ``S.<f>`` only for an ``f`` the stub asks the policy to
    write.

    ``LAWS.bend`` imports ``./solution.bend as S``, and the solution does not
    re-export the prelude, so a law that means the prelude's ``len`` has to say
    ``P.len``. Written as ``S.len`` it still parses and still reads like a law,
    and the checker answers with "expected : a defined name / observed : S.len"
    pointing into the law -- which reads like a proof that is wrong rather than
    a task that is. This is the cheaper place to find out.

    Checked here rather than in V1 because it is a property of the task's own
    files, knowable without running the checker, and V1 cannot see it at all
    when the reference happens to be broken for some other reason first.
    """
    defined = {c.name for c in split_top_level(task.stub_src) if c.kind == "def"}
    # Comments stripped: the bank's laws are heavily commented, and a comment
    # that mentions `S.len` while explaining the law is not a citation.
    body = "\n".join(line.split("#", 1)[0] for line in task.laws_src.splitlines())
    cited = set(re.findall(r"\bS\.([A-Za-z_][A-Za-z0-9_]*)", body))
    unknown = sorted(cited - defined)
    if unknown:
        report.problems.append(
            f"posed: LAWS.bend cites {', '.join('S.' + n for n in unknown)}, "
            f"but solution.bend defines only {sorted(defined) or 'nothing'}. "
            f"The law file imports solution.bend as S, which does not re-export "
            f"the prelude: anything the policy is not being asked to write is "
            f"P.")


# --- V1: the reference proves every law ----------------------------------------

def _v1_reference(task: Task, toolchain: Toolchain, config: CheckConfig,
                  report: TaskReport, budget_ms: int) -> None:
    verdict = check_submission(task, toolchain, {
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.reference_proof,
    }, config)
    report.checked.append("reference")
    report.reference_ms = max((c.ms for c in verdict.checks), default=0)
    report.reference_total_ms = verdict.ms
    if verdict.tier != TIER_COMPLETE:
        report.problems.append(
            f"V1: reference is tier {verdict.tier} ({verdict.tier_name}), not 4"
            + (f"; unproven: {', '.join(verdict.failed)}" if verdict.failed else ""))
    elif tuple(verdict.proven) != tuple(task.laws):
        # Reachable only if the law list and the checker disagree about which
        # names are laws, which is worth knowing before it becomes a reward.
        report.problems.append(
            f"V1: reference proved {list(verdict.proven)}, "
            f"but LAWS.bend declares {list(task.laws)}")


# --- V2: mutants of the reference must not prove the laws ----------------------

def mutant_verdicts(task: Task, toolchain: Toolchain, source: str,
                    config: CheckConfig) -> tuple[Any, Any]:
    """A mutant's solution under the reference proof, and under no proof.

    Two different questions, and tier alone answers neither. The first run asks
    whether the task's laws catch the mutant -- it must not reach tier 4. The
    second asks whether the mutant *type-checks*, which is what makes the first
    run evidence about a law rather than about a coverage error: a solution
    that does not type-check fails the reference proof for reasons that have
    nothing to do with what the law says.
    """
    against_proof = check_submission(task, toolchain, {
        SOLUTION_FILE: source, PROOF_FILE: task.reference_proof}, config)
    bare = check_submission(task, toolchain, {
        SOLUTION_FILE: source, PROOF_FILE: task.proof_header}, config)
    return against_proof, bare


def _v2_mutants(task: Task, toolchain: Toolchain, config: CheckConfig,
                report: TaskReport) -> None:
    """A law is only as strong as the wrong solutions it rules out.

    Two failures matter, and they are different. A mutant that still reaches
    tier 4 means the law does not constrain the solution at all -- the task
    would pay full reward for a wrong answer. A corpus in which *every* mutant
    fails to type-check means none of them ever reached a law: the corpus only
    looks like evidence, and the task is unguarded.
    """
    mutants = task.mutant_paths
    if not mutants:
        report.problems.append("V2: no mutants authored -- laws unguarded")
        return
    escaped, strong, kills = [], [], {}
    for path in mutants:
        source = path.read_text()
        against_proof, bare = mutant_verdicts(task, toolchain, source, config)
        report.checked.append(f"mutant:{path.stem}")
        report.mutant_tiers.append(against_proof.tier)
        if against_proof.tier == TIER_COMPLETE:
            escaped.append(path.name)
        elif bare.tier > TIER_NO_CHECK:
            strong.append((path.name, against_proof.tier))
            # Which laws caught it, read off the verdict V2 already paid for
            # rather than from a per-law run: the checker's fixed point names
            # every law it could not prove, so a type-checking mutant's failed
            # list is its kill list. SPEC 12's "mean mutants killed per law" is
            # the mean of this, and a law nothing kills is what it is for.
            for law in against_proof.failed:
                kills[law] = kills.get(law, 0) + 1
    report.mutant_strong = strong
    report.mutant_kills = kills
    if escaped:
        report.problems.append(
            f"V2: {len(escaped)} mutant(s) still prove every law: {', '.join(escaped)}")
    elif not strong:
        report.problems.append(
            f"V2: none of the {len(mutants)} mutants type-checks -- they fail "
            f"before a law is consulted, so the corpus proves nothing")


# --- V3: a submission that proves nothing must not score -----------------------

def _v3_degenerate(task: Task, toolchain: Toolchain, config: CheckConfig,
                   report: TaskReport) -> None:
    """The floor of the reward function, checked directly.

    V2 asks whether a *nearly right* solution is caught. This asks the weaker
    and more important question: is an obviously empty one caught at all. A
    task that pays tier 4 for any of these is not a task.
    """
    # Nothing below is evidence if the corpus could not be built. A generated
    # solution missing a function the laws call is a type error, so every
    # attempt lands at tier 1 and V3 passes without having asked anything --
    # which is worse than failing, because it reports "fine".
    blind = unmodelled(task.stub_src)
    if blind:
        report.warnings.append(
            f"V3: the degenerate corpus cannot rebuild {', '.join(blind)} from "
            f"the stub, so its submissions are incomplete and V3 tested nothing")

    for attempt in corpus(task):
        verdict = check_submission(task, toolchain, dict(attempt.files), config)
        report.checked.append(f"degenerate:{attempt.name}")
        if attempt.must_be_gate_rejected:
            if verdict.gate is None or verdict.gate.ok:
                report.problems.append(
                    f"V3: {attempt.name} was not rejected by the gate")
            continue
        if verdict.tier == TIER_COMPLETE:
            report.problems.append(
                f"V3: {attempt.name} proves every law -- the task's reward "
                f"can be earned without solving it")


# --- V4: the reference checks inside the budget --------------------------------

def _v4_latency(report: TaskReport, budget_ms: int) -> None:
    if report.reference_ms > budget_ms:
        report.problems.append(
            f"V4: the reference's slowest run took {report.reference_ms}ms, "
            f"over the {budget_ms}ms budget")


def _prelude_compiles(task: Task, toolchain: Toolchain, config: CheckConfig,
                      report: TaskReport) -> None:
    """The prelude is type-checked whether or not any law calls it.

    A task's ``prelude.bend`` is imported by the task's own laws, so the checker
    elaborates it as part of every book in the task -- including the reference.
    A linearity error inside it therefore fails *every* submission, and the
    diagnostic names a Location inside the prelude while the invariant that
    reports it is V1 saying "reference is tier 1", which points at the
    reference. Two shipped tasks were in exactly this state and cost an author
    an afternoon each: a Lone binder used twice, in ``double_all`` and in
    ``replicate``/``mul``.

    Checked here, on a book that imports the prelude and nothing else, so the
    message names the file that is actually wrong. Also the cheapest place to
    find it: one run, before V1 pays for the reference.
    """
    if not task.prelude_src.strip():
        return
    book = f"import Base\nimport ./{PRELUDE_FILE} as P\n"
    workdir = prepare_workdir(task, {PROOF_FILE: book},
                              parent=config.workdir_parent)
    try:
        result = run_check(toolchain, workdir, PROOF_FILE, config.limits,
                           select_backend(config.backend))
    finally:
        cleanup(workdir)
    report.checked.append("prelude")
    if result.ok:
        return
    report.problems.append(
        f"prelude: {PRELUDE_FILE} does not type-check on its own "
        f"({_first_diagnostic(result.stderr)}). The task's laws import it, so "
        f"every book in this task fails with a Location inside this file -- "
        f"which V1 reports as the reference being wrong.")


def _first_diagnostic(stderr: str) -> str:
    """The part of Bend's error block a person would read.

    ``err_show`` prints ``Error:``, then one ``- name : value`` line per field,
    then ``Location:``. Taking the first non-empty line gets the heading, which
    says nothing; the fields and the location are the whole content.
    """
    lines = [line.strip() for line in stderr.splitlines() if line.strip()]
    fields = [line for line in lines if line.startswith("-")]
    location = next((line for line in lines if line.startswith("Location:")), "")
    if not fields:
        return " ".join(lines[:3]) or "no diagnostic"
    return " ".join([*fields[:2], location]).strip()


# --- V5: the immutable files carry no forbidden construct ----------------------

def _v5_immutable_files(task: Task, report: TaskReport) -> None:
    for name, text in ((LAWS_FILE, task.laws_src), (PRELUDE_FILE, task.prelude_src)):
        try:
            chunks = split_top_level(text)
        except Exception as exc:                      # noqa: BLE001 - reported, not raised
            report.problems.append(f"V5: {name} does not lex ({exc})")
            continue
        for chunk in chunks:
            if chunk.unsafe:
                report.problems.append(
                    f"V5: {name} declares {chunk.name} @unsafe at line {chunk.line}")
        for spec in parse_imports(text):
            if spec.path is None:
                report.problems.append(f"V5: {name} has a malformed import "
                                       f"({spec.raw})")
            elif spec.path not in IMMUTABLE_IMPORTS:
                report.problems.append(
                    f"V5: {name} imports {spec.path}, which is outside the task")


def validate_bank(tasks: list[Task], toolchain: Toolchain,
                  **kwargs: Any) -> list[TaskReport]:
    return [validate_task(task, toolchain, **kwargs) for task in tasks]


# --- SPEC 12's environment-quality metrics, over a bank release ----------------

def bank_metrics(reports: list[TaskReport]) -> dict[str, Any]:
    """The half of SPEC 12 that is about the bank rather than about a run.

    These are not V1-V5 and could not be: no single task can fail them, which is
    exactly why they went unbuilt. They are derived from the reports validation
    already produced, so a bank report cannot disagree with the validation that
    licensed it -- the same reason ``gavel/metrics.py`` derives a run's numbers
    from its episode records.

    ``mutants_killed_per_law`` and the calibration block are measurements.
    ``recorded_fraction`` is not, and is the one that matters to M4. It counts
    records that match the laws they are recorded against, which is what
    ``review_state`` can witness -- and it cannot see who wrote one. Measured on
    the bank it reads 8 of 39, every one of those eight a record the authoring
    agent wrote for itself; the human-reviewed figure is **0 of 39**. So the
    fraction is an upper bound that the bank's own history shows is entirely
    reachable without review, and it is reported next to the raw counts rather
    than alone so that a reader gets the four states and not just the quotient.
    It is named for what it measures: a record, not the judgement a record is
    supposed to be evidence of.

    A law's kill count is keyed by *task and law*, because ``add_plus`` in one
    task and ``add_plus`` in another are two declarations and a mean over their
    sum is a mean over neither. Every law in the bank is seeded at zero before
    the corpus is read, so a law that **no mutant kills** reads 0 and is counted
    in the denominator. Seeding from the corpora alone would drop it, which is
    the same mistake as a corpus that misses it: ``min`` exists to surface that
    law, and a missing key is a value the report would never show.
    """
    tiers: dict[int, int] = {}
    review: dict[str, int] = {}
    kills: dict[str, int] = {}
    rated: list[float] = []
    for report in reports:
        tiers[report.tier] = tiers.get(report.tier, 0) + 1
        review[report.review] = review.get(report.review, 0) + 1
        for law in report.laws:
            kills.setdefault(f"{report.task_id}/{law}", 0)
        for law, count in report.mutant_kills.items():
            key = f"{report.task_id}/{law}"
            kills[key] = kills.get(key, 0) + count
        if report.zero_shot_solve_rate is not None:
            rated.append(report.zero_shot_solve_rate)

    needs_review = sum(review.get(state, 0)
                       for state in ("current", "stale", "unreviewed"))
    current = review.get("current", 0)
    return {
        "tasks": len(reports),
        "tasks_by_tier": {str(tier): tiers[tier] for tier in sorted(tiers)},
        "review": {
            **{state: review.get(state, 0) for state in
               ("current", "stale", "unreviewed", "none-needed")},
            "needs_review": needs_review,
            "recorded_fraction": (round(current / needs_review, 4)
                                  if needs_review else None),
        },
        "mutants_killed_per_law": {
            "mean": round(sum(kills.values()) / len(kills), 2) if kills else None,
            "min": min(kills.values()) if kills else None,
            "laws": len(kills),
        },
        "calibration": {
            "recorded": len(rated),
            "missing": len(reports) - len(rated),
            "mean_solve_rate": round(sum(rated) / len(rated), 4) if rated else None,
        },
    }


__all__ = ["DEFAULT_BUDGET_MS", "IMMUTABLE_IMPORTS", "REVIEW_TIER", "TaskReport",
           "bank_metrics", "review_state", "validate_bank", "validate_task"]
