"""Validate the task bank against V1-V5, as a CI job would.

    uv run python -m tools.validate               # every task in the manifest
    uv run python -m tools.validate t1-add-plus   # just these
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
from gavel.validate import (DEFAULT_BUDGET_MS, REVIEW_TIER,  # noqa: E402
                            bank_metrics, validate_task)

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

    failed = [r for r in reports if not r.valid]

    if args.json:
        # Nothing but the document. The summary lines below used to follow it,
        # which made ``--json`` unparseable by exactly the callers it exists for
        # -- and the bank block is SPEC 12's export, so a reader has to be able
        # to load it. The exit code still reports validity.
        print(json.dumps({"toolchain_hash": toolchain.tree_hash,
                          "strict": args.strict,
                          "budget_ms": args.budget_ms,
                          "bank": bank_metrics(reports),
                          "tasks": [r.to_json() for r in reports]}, indent=2))
        return 1 if failed else 0

    if not args.quiet:
        for report in reports:
            notes = report.problems or report.warnings
            status = "ok  " if report.valid else "FAIL"
            print(f"[{status}] {report.task_id:24s} tier {report.tier}  "
                  f"{report.reference_ms:5d}ms  {len(report.checked):2d} check(s)  "
                  f"{'; '.join(notes) or 'V1-V5 pass'}")

    unchecked = [r for r in reports if r.warnings]
    print(f"\n{len(reports) - len(failed)}/{len(reports)} valid, "
          f"{len(unchecked)} with unchecked invariants, "
          f"{sum(len(r.checked) for r in reports)} checker runs")
    # Said out loud rather than left to be reconstructed from the warnings: a
    # bank whose review records are forged and stale must not have to be read
    # closely to find that out, and the two are different defects -- an absent
    # record is honest, a record about other laws is not.
    stale = [r.task_id for r in reports if r.review == "stale"]
    unreviewed = [r.task_id for r in reports if r.review == "unreviewed"]
    if stale:
        print(f"{len(stale)} recorded against laws that no longer ship: "
              f"{', '.join(stale)}")
    if unreviewed:
        print(f"{len(unreviewed)} at tier {REVIEW_TIER}+ with no review record: "
              f"{', '.join(unreviewed)}")

    # SPEC 12's environment-quality metrics, over whatever was validated -- the
    # whole bank by default, and a subset when task ids are given, which is why
    # the line says how many tasks it is about rather than assuming the bank.
    bank = bank_metrics(reports)
    tiers = " ".join(f"t{tier}:{count}"
                     for tier, count in bank["tasks_by_tier"].items())
    killed, review = bank["mutants_killed_per_law"], bank["review"]
    print(f"bank: {bank['tasks']} tasks ({tiers}); "
          f"reviewed {review['approved']}/{review['needs_review']} "
          f"at tier {REVIEW_TIER}+; mutants killed per law "
          f"mean {killed['mean']}, min {killed['min']}; "
          f"calibration {bank['calibration']['recorded']}/{bank['tasks']}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
