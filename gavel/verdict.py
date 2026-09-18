"""The value types that cross every module boundary.

Kept in one file with no imports so that anything -- gate, runner, checker,
env, CLI -- can speak them without a cycle.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

# Reward tiers (SPEC.md 8). Tier 0 and 1 both score 0.0 but stay distinct so a
# training pipeline can penalize gate failures separately.
TIER_REJECTED = 0    # the gate refused the submission
TIER_NO_CHECK = 1    # gate passed; the submission is not a well-typed program
TIER_CHECKS = 2      # the solution type-checks; no law is proven
TIER_PARTIAL = 3     # the solution checks; a strict subset of laws is proven
TIER_COMPLETE = 4    # every law is proven

TIER_NAMES = {
    TIER_REJECTED: "rejected",
    TIER_NO_CHECK: "no-check",
    TIER_CHECKS: "checks",
    TIER_PARTIAL: "partial",
    TIER_COMPLETE: "complete",
}


@dataclass(frozen=True)
class GateFinding:
    """One reason the gate refused a submission."""

    code: str
    message: str
    file: str = ""
    line: int = 0

    def __str__(self) -> str:
        where = f"{self.file}:{self.line}: " if self.file else ""
        return f"{where}[{self.code}] {self.message}"

    def to_json(self) -> dict[str, Any]:
        return {"code": self.code, "message": self.message,
                "file": self.file, "line": self.line}


@dataclass(frozen=True)
class GateResult:
    ok: bool
    findings: tuple[GateFinding, ...] = ()
    hashes: tuple[tuple[str, str], ...] = ()  # (logical name, sha256) as submitted

    @property
    def codes(self) -> tuple[str, ...]:
        return tuple(f.code for f in self.findings)

    def to_json(self) -> dict[str, Any]:
        return {"passed": self.ok, "findings": [f.to_json() for f in self.findings]}


@dataclass(frozen=True)
class CheckResult:
    """One invocation of the checker on one file.

    ``ok`` is deliberately stricter than the exit code. Measured against 2.0.5:
    a file carrying ``@unsafe`` exits 0 while replacing the success line with a
    warning, and a file declaring ``main`` exits 0 while replacing the success
    line with that program's output. Neither is a proof, so success is keyed on
    the exact sentence the checker prints when it has accepted every term.
    """

    ok: bool
    exit_code: int | None
    ms: int
    success_line: bool = False
    unsafe_warning: bool = False
    todo_count: int | None = None
    timed_out: bool = False
    error_block: str | None = None
    error_location: str | None = None
    stdout: str = ""
    stderr: str = ""
    backend: str = "plain"
    """Which isolation the check ran under: ``plain`` or ``bwrap``.

    A verdict does not say how much it can be trusted unless it says whether the
    process was sandboxed, so the name travels with the result rather than
    living in the caller's configuration.
    """

    @property
    def failure_kind(self) -> str:
        if self.timed_out:
            return "timeout"
        if self.ok:
            return "ok"
        if self.unsafe_warning:
            return "unsafe"
        if self.todo_count is not None:
            return "todo"
        if self.error_block is not None:
            return "type-error"
        return "failure"

    def feedback(self, limit: int = 4096) -> str:
        """What the policy is shown: the checker's own words, unmodified.

        Bend's terse errors are the training signal for repair (SPEC.md 6.2), so
        nothing is prettified -- only truncated to a byte budget.
        """
        text = self.stderr.strip() or self.stdout.strip()
        if not text:
            text = f"the checker exited {self.exit_code} with no output"
        if len(text) > limit:
            text = text[:limit] + "\n... (truncated)"
        return text

    def to_json(self) -> dict[str, Any]:
        return {
            "exit": self.exit_code,
            "ok": self.ok,
            "kind": self.failure_kind,
            "ms": self.ms,
            "backend": self.backend,
            "todo_count": self.todo_count,
            "location": self.error_location,
            "stderr": self.stderr[:4096],
            "stdout": self.stdout[:4096],
        }


@dataclass(frozen=True)
class Verdict:
    """The structured result of one episode (SPEC.md 3)."""

    task_id: str
    tier: int
    reward: float
    n_laws: int
    proven: tuple[str, ...] = ()
    failed: tuple[str, ...] = ()
    gate: GateResult | None = None
    checks: tuple[CheckResult, ...] = ()
    toolchain_hash: str = ""
    task_hash: str = ""
    submission_hash: str = ""
    difficulty_weight: float = 1.0
    ms: int = 0
    incident: str | None = None

    @property
    def solved(self) -> bool:
        return self.tier == TIER_COMPLETE

    @property
    def weighted_reward(self) -> float:
        return self.reward * self.difficulty_weight

    @property
    def tier_name(self) -> str:
        return TIER_NAMES.get(self.tier, f"tier-{self.tier}")

    def to_json(self) -> dict[str, Any]:
        return {
            "task_id": self.task_id,
            "tier": self.tier,
            "tier_name": self.tier_name,
            "reward": self.reward,
            "difficulty_weight": self.difficulty_weight,
            "weighted_reward": self.weighted_reward,
            "n_laws": self.n_laws,
            "laws_proven": list(self.proven),
            "laws_failed": list(self.failed),
            "gate": self.gate.to_json() if self.gate is not None else None,
            "checker": self.checks[-1].to_json() if self.checks else None,
            "checks": [c.to_json() for c in self.checks],
            "toolchain_hash": self.toolchain_hash,
            "task_hash": self.task_hash,
            "submission_hash": self.submission_hash,
            "ms": self.ms,
            "incident": self.incident,
        }
