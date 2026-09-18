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

from dataclasses import dataclass, field
from typing import Any

from .check import CheckConfig, check_submission
from .degenerate import corpus
from .laws import parse_imports, split_top_level
from .tasks import LAWS_FILE, PRELUDE_FILE, PROOF_FILE, SOLUTION_FILE, Task
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
