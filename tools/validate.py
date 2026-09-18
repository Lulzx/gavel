"""Validate the task bank against V1-V5, as a CI job would.

    uv run python -m tools.validate               # every task in the manifest
    uv run python -m tools.validate t1-add-succ   # just these
    uv run python -m tools.validate --json
    uv run python -m tools.validate --strict      # warnings fail the build
    uv run python -m tools.validate --jobs 4      # one process per task

Exit code is 0 when every task is valid and 1 otherwise, so this can gate a
merge without anyone reading the output. ``--strict`` is the mode CI should
use once the mutant and degenerate corpora are authored; until then it fails on
the honest "not checked yet" warnings, which is the point.
"""

from __future__ import annotations

import argparse
import json
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.tasks import load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain, ToolchainError  # noqa: E402
from gavel.validate import DEFAULT_BUDGET_MS, validate_task  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tasks", nargs="*", help="task ids; default is all")
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--budget-ms", type=int, default=DEFAULT_BUDGET_MS,
                        help="V4 latency budget for the reference")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--strict", action="store_true",
                        help="treat unchecked invariants as failures")
    parser.add_argument("--quiet", action="store_true",
                        help="print only the summary")
    parser.add_argument("--jobs", type=int, default=1,
                        help="validate this many tasks at once. Off by default "
                             "because V4 reads wall-clock latency: running checks "
                             "concurrently inflates the measurement it is checking, "
                             "so a loaded box can fail a task that is fine")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    try:
        toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
    except ToolchainError as exc:
        print(f"validate: {exc}", file=sys.stderr)
        return 2

    tasks = [manifest.get(name) for name in args.tasks] if args.tasks else list(manifest)

    def _validate(task):
        return validate_task(task, toolchain, budget_ms=args.budget_ms,
                             strict=args.strict)

    if args.jobs > 1 and len(tasks) > 1:
        # A task's checks are independent: each gets its own workdir and its own
        # checker process, and nothing in the check path mutates shared state.
        # `map` keeps the reports in task order, so the output is the same
        # whether or not this ran concurrently -- except for the timings.
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            reports = list(pool.map(_validate, tasks))
    else:
        reports = [_validate(task) for task in tasks]

    if args.json:
        print(json.dumps({"toolchain_hash": toolchain.tree_hash,
                          "strict": args.strict,
                          "budget_ms": args.budget_ms,
                          "tasks": [r.to_json() for r in reports]}, indent=2))
    elif not args.quiet:
        for report in reports:
            notes = report.problems or report.warnings
            status = "ok  " if report.valid else "FAIL"
            print(f"[{status}] {report.task_id:24s} tier {report.tier}  "
                  f"{report.reference_ms:5d}ms  {len(report.checked):2d} check(s)  "
                  f"{'; '.join(notes) or 'V1-V5 pass'}")

    failed = [r for r in reports if not r.valid]
    unchecked = [r for r in reports if r.warnings]
    print(f"\n{len(reports) - len(failed)}/{len(reports)} valid, "
          f"{len(unchecked)} with unchecked invariants, "
          f"{sum(len(r.checked) for r in reports)} checker runs")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
