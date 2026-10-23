"""Look for bodies the laws accept and the reference disagrees with.

    uv run python -m tools.holes                       # the whole bank
    uv run python -m tools.holes t3-absdiff-comm -v    # one task, every candidate
    uv run python -m tools.holes --jobs 8 --json out.json

Every candidate is evaluated by ``gavel/ground.py`` -- the laws at small closed
points, and the cited functions against the reference at the same points -- so
no proof is involved and a reference proof that happens not to fit a body
cannot pass for a law that rejects it. The candidates are the task's shipped
mutants, every mutant ``tools/mutate.py``'s rules derive from the reference,
and the argument-ignoring bodies of ``gavel/degenerate.py``.

A ``hole`` is printed with the input it disagrees on. It is a defect in the
law set: a policy that writes that body and proves the laws for it is paid in
full. The exit status is 1 when any task has one, or when a reference fails its
own laws at a point, which would mean this screen is reading a law wrong.
"""

from __future__ import annotations

import argparse
import json
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel import ground  # noqa: E402
from gavel.degenerate import corpus  # noqa: E402
from gavel.tasks import SOLUTION_FILE, load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from tools.mutate import dedupe, mutants_of  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent


def candidates(task) -> list[tuple[str, str]]:
    """``(label, solution source)``, without repeats or the reference itself."""
    reference = task.reference_solution
    seen = {reference.strip()}
    out = []

    def add(label: str, source: str) -> None:
        if source.strip() in seen:
            return
        seen.add(source.strip())
        out.append((label, source))

    for path in task.mutant_paths:
        add(f"shipped:{path.stem}", path.read_text())
    for mutant in dedupe(mutants_of(reference), reference):
        add(f"generated:{mutant.name}", mutant.source)
    for attempt in corpus(task):
        if attempt.name.startswith(("vary-", "identity-", "constant-")):
            add(f"degenerate:{attempt.name.split('+')[0]}",
                attempt.files[SOLUTION_FILE])
    return out


def screen_task(task, toolchain) -> dict:
    the_plan = ground.plan(task)
    row = {"task_id": task.task_id, "tier": task.tier,
           "instances": len(the_plan.instances), "probes": len(the_plan.probes),
           "unread": the_plan.unread, "uncovered": the_plan.uncovered,
           "reference": None, "outcomes": {}, "holes": [], "vacuous": []}
    reference = ground.evaluate(task, toolchain, task.reference_solution, the_plan)
    row["reference"] = reference.outcome
    row["vacuous"] = reference.vacuous
    if reference.outcome != "equivalent":
        row["reference_detail"] = (reference.violations[:3] or [reference.error])
        return row
    for label, source in candidates(task):
        report = ground.evaluate(task, toolchain, source, the_plan)
        row["outcomes"][report.outcome] = row["outcomes"].get(report.outcome, 0) + 1
        if report.outcome == "hole":
            row["holes"].append({"candidate": label,
                                 "differences": report.differences[:3],
                                 "source": source})
    return row


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tasks", nargs="*")
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--jobs", "-j", type=int, default=4)
    parser.add_argument("--json", help="write the full report here")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="print each hole's source")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    tasks = [manifest.get(t) for t in args.tasks] if args.tasks else list(manifest)
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)

    with ThreadPoolExecutor(max_workers=max(args.jobs, 1)) as pool:
        rows = list(pool.map(lambda t: screen_task(t, toolchain), tasks))

    bad = 0
    for row in rows:
        gaps = row["unread"] + row["uncovered"]
        flag = ("HOLE" if row["holes"] else
                "REF " if row["reference"] != "equivalent" else "ok  ")
        bad += flag != "ok  "
        counts = " ".join(f"{k}={v}" for k, v in sorted(row["outcomes"].items()))
        print(f"[{flag}] {row['task_id']:28s} {counts}"
              + (f"  gaps: {'; '.join(gaps)}" if gaps else "")
              + (f"  vacuous: {', '.join(row['vacuous'])}" if row["vacuous"] else ""))
        if row["reference"] != "equivalent":
            print(f"        reference {row['reference']}: {row.get('reference_detail')}")
        for hole in row["holes"]:
            print(f"        {hole['candidate']}: {hole['differences'][0]}")
            if args.verbose:
                print("          " + hole["source"].replace("\n", "\n          "))
    holes = sum(len(r["holes"]) for r in rows)
    print(f"\n{len(rows)} task(s), {sum(1 for r in rows if r['holes'])} with holes "
          f"({holes} hole(s)), "
          f"{sum(1 for r in rows if r['reference'] != 'equivalent')} reference "
          f"failure(s)")
    if args.json:
        Path(args.json).write_text(json.dumps(rows, indent=2) + "\n")
    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
