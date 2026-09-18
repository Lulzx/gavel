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
    zero_shot_solve_rate: float | None = None

    @property
    def valid(self) -> bool:
        return not self.problems

    def to_json(self) -> dict[str, Any]:
        return {
            "task_id": self.task_id,
            "tier": self.tier,
            "valid": self.valid,
            "problems": list(self.problems),
            "warnings": list(self.warnings),
            "reference_ms": self.reference_ms,
            "reference_total_ms": self.reference_total_ms,
            "laws": list(self.laws),
            "hash": self.hash,
            "checked": list(self.checked),
            "mutant_tiers": list(self.mutant_tiers),
            "mutant_strong": [name for name, _ in self.mutant_strong],
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

    # Not an invariant so much as a missing measurement: M0's exit criterion is
    # stated as a solve rate, and a task nobody has calibrated is a task whose
    # difficulty is assumed. tools/calibrate.py --write-meta fills this in.
    if report.zero_shot_solve_rate is None:
        report.warnings.append("calibration: no zero_shot_solve_rate recorded")

    if strict:
        report.problems.extend(report.warnings)
        report.warnings = []
    return report


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
    escaped, strong = [], []
    for path in mutants:
        source = path.read_text()
        against_proof, bare = mutant_verdicts(task, toolchain, source, config)
        report.checked.append(f"mutant:{path.stem}")
        report.mutant_tiers.append(against_proof.tier)
        if against_proof.tier == TIER_COMPLETE:
            escaped.append(path.name)
        elif bare.tier > TIER_NO_CHECK:
            strong.append((path.name, against_proof.tier))
    report.mutant_strong = strong
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


__all__ = ["DEFAULT_BUDGET_MS", "IMMUTABLE_IMPORTS", "TaskReport", "validate_bank",
           "validate_task"]
