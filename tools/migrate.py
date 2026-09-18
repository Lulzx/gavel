"""Re-validate the whole bank against a different checker and quarantine what breaks.

Bend went 2.0.3 -> 2.0.5 in under 24 hours while this project was being built, so
"the bank is valid" is a statement about one toolchain and not about the bank.
A version bump can turn a proof into a parse error, and the failure is worth
finding in a report rather than in a training run where it looks like the policy
suddenly got worse.

    uv run python -m tools.migrate --to 2.0.5              # a control: no churn
    uv run python -m tools.migrate --from ~/.bend/app/2.0.4 --label 2.0.4
    uv run python -m tools.migrate --from <dir> --report quarantine.json

``--from`` takes a directory that *contains* ``bend2/`` -- that is the layout of
the launcher's own ``~/.bend/app/<version>/<id>/``, so a candidate checker can be
measured without vendoring it. Nothing here writes to the repository: the
report is the output, and moving the bank forward stays a decision someone makes
after reading it.

Exit code is 0 when every task survives the candidate toolchain and 1 when any
task is quarantined.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from gavel.check import CheckConfig, check_submission  # noqa: E402
from gavel.hashing import tree_hash  # noqa: E402
from gavel.tasks import (PROOF_FILE, SOLUTION_FILE, load_manifest)  # noqa: E402
from gavel.toolchain import (DEFAULT_VERSION, SOURCE_DIR, Toolchain,  # noqa: E402
                             ToolchainError, _resolve_bun)
from gavel.validate import validate_task  # noqa: E402
from gavel.verdict import TIER_COMPLETE  # noqa: E402

DEFAULT_REPORT = "quarantine.json"


@dataclass
class Migration:
    """One task's fate under the candidate checker."""

    task_id: str
    tier: int
    valid: bool
    problems: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    reference_ms: int = 0
    reference_tier: int = 0
    evidence: str = ""
    """The checker's own words for the first thing that went wrong, unedited.

    A report that says "V1: reference is tier 1" makes a reader open a
    terminal. The `Location:` line and the `expected/observed` block usually
    name the migration in one glance, which is the whole point of a dry run.
    """

    @property
    def quarantined(self) -> bool:
        return not self.valid

    def to_json(self) -> dict[str, Any]:
        return {"task_id": self.task_id, "tier": self.tier, "valid": self.valid,
                "quarantined": self.quarantined, "problems": list(self.problems),
                "warnings": list(self.warnings),
                "reference_ms": self.reference_ms,
                "reference_tier": self.reference_tier,
                "evidence": self.evidence}


def candidate_toolchain(args: argparse.Namespace) -> Toolchain:
    """The checker to migrate *to*.

    ``--from`` reads a directory that already holds ``bend2/``. The tree hash is
    still computed and recorded, so the report says exactly which bytes were
    tested -- but a hash of the only copy is an identity, not a pin, and this
    path is for measuring churn rather than for vendoring.
    """
    bun = _resolve_bun(None)
    try:
        bun_version = subprocess.run([str(bun), "--version"], capture_output=True,
                                     text=True, check=True, timeout=30).stdout.strip()
    except (subprocess.SubprocessError, OSError) as exc:
        raise ToolchainError(f"could not run {bun} --version: {exc}") from exc

    if args.source is not None:
        home = Path(args.source).expanduser().resolve()
        if not (home / SOURCE_DIR / "main.ts").is_file():
            raise ToolchainError(
                f"{home} does not contain {SOURCE_DIR}/main.ts; point --from at "
                f"the directory that holds {SOURCE_DIR}/")
        version = args.label or home.name
        return Toolchain(version=version, root=home, bun=bun, bun_version=bun_version,
                         tree_hash=tree_hash(home / SOURCE_DIR))

    return Toolchain.load(args.to or DEFAULT_VERSION, bun=bun, verify=True)


def migrate_bank(manifest_path: Path, candidate: Toolchain, config: CheckConfig,
                 budget_ms: int) -> list[Migration]:
    """Every task, judged by the candidate checker.

    V1-V5 are the whole judge. A task the candidate cannot prove the reference
    for is quarantined whatever else passes, and the evidence field carries the
    checker's own error text so the report can be read without re-running
    anything.
    """
    manifest = load_manifest(manifest_path)
    migrations: list[Migration] = []
    for task in manifest:
        report = validate_task(task, candidate, budget_ms=budget_ms, config=config)
        row = Migration(task_id=task.task_id, tier=task.tier, valid=report.valid,
                        problems=list(report.problems),
                        warnings=list(report.warnings),
                        reference_ms=report.reference_ms)
        verdict = check_submission(task, candidate, {
            SOLUTION_FILE: task.reference_solution,
            PROOF_FILE: task.reference_proof}, config)
        row.reference_tier = verdict.tier
        if verdict.tier != TIER_COMPLETE:
            for check in reversed(verdict.checks):
                if not check.ok and (check.stderr.strip() or check.stdout.strip()):
                    row.evidence = (check.stderr.strip() or check.stdout.strip())[:2000]
                    break
            if not row.evidence and verdict.gate is not None and not verdict.gate.ok:
                row.evidence = "\n".join(str(f) for f in verdict.gate.findings)
        migrations.append(row)
    return migrations


def summarise(migrations: list[Migration], candidate: str) -> dict[str, Any]:
    quarantined = [m for m in migrations if m.quarantined]
    return {
        "candidate": candidate,
        "tasks": len(migrations),
        "clean": len(migrations) - len(quarantined),
        "quarantined": len(quarantined),
        "by_tier": _by_tier(migrations),
        "report": [m.to_json() for m in migrations],
    }


def _by_tier(migrations: list[Migration]) -> dict[str, dict[str, int]]:
    out: dict[str, dict[str, int]] = {}
    for migration in migrations:
        bucket = out.setdefault(str(migration.tier), {"clean": 0, "quarantined": 0})
        bucket["quarantined" if migration.quarantined else "clean"] += 1
    return out


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--to", help="a vendored version to migrate to")
    parser.add_argument("--from", dest="source", metavar="DIR",
                        help="a directory containing bend2/, e.g. the launcher's")
    parser.add_argument("--label", help="what to call the candidate in the report")
    parser.add_argument("--report", default=str(REPO_ROOT / DEFAULT_REPORT),
                        help="where to write the quarantine report")
    parser.add_argument("--budget-ms", type=int, default=2000)
    parser.add_argument("--backend", default=None,
                        help="process isolation; default is the environment's")
    parser.add_argument("--json", action="store_true",
                        help="print the report instead of a table")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args(argv)

    manifest_path = Path(args.manifest)
    config = CheckConfig(**({"backend": args.backend} if args.backend else {}))
    try:
        candidate = candidate_toolchain(args)
    except ToolchainError as exc:
        print(f"migrate: {exc}", file=sys.stderr)
        return 2

    print(f"migrating {manifest_path} to {candidate.version} "
          f"(tree {candidate.tree_hash[:12]}, bun {candidate.bun_version})")

    try:
        migrations = migrate_bank(manifest_path, candidate, config, args.budget_ms)
    except ToolchainError as exc:
        print(f"migrate: {exc}", file=sys.stderr)
        return 2

    summary = summarise(migrations, candidate.version)
    summary["toolchain"] = candidate.to_json()

    if not args.quiet:
        for row in migrations:
            status = "FAIL" if row.quarantined else "ok  "
            notes = row.problems or row.warnings
            print(f"[{status}] {row.task_id:24s} tier {row.tier}  "
                  f"{row.reference_ms:5d}ms  {row.reference_tier}/4  "
                  f"{'; '.join(notes) or 'migrated cleanly'}")

    Path(args.report).write_text(json.dumps(summary, indent=2) + "\n")
    if args.json:
        print(json.dumps(summary, indent=2))
    elif not args.quiet:
        print(f"\n{summary['clean']}/{summary['tasks']} clean, "
              f"{summary['quarantined']} quarantined -> {args.report}")
    return 1 if summary["quarantined"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
