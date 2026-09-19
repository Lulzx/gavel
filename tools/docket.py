"""Assemble the reading a tier-3+ review actually needs, one task per block.

    uv run python -m tools.docket               # every task tier 3 or above
    uv run python -m tools.docket t3-last-snoc  # just these
    uv run python -m tools.docket --static      # no checker runs
    uv run python -m tools.docket --jobs 8      # this many tasks at once

The review checkpoint is a gate a person has to clear, and nothing here can
clear it: a record written by the machine that needs the judgement is the
forgery Fact 27 removed. What this can do is make the reading cheap. Every
law set at tier 3+ already ships its fix, so what a reviewer lacks is not
access to the laws, it is *triage* -- which of the twenty-odd laws in a task,
and which of the thirty-odd tasks, are worth a second look. That reading is
derivable and was scattered across three tools, so it is joined here.

The order is the reviewer's order. Each block ends with the task's own
findings, and the SHORTLIST at the bottom lists the tasks that have any, so
the reading can start there and stop when it runs out of findings.

What a finding is, and why each one points where it does:

  zero-kill law      no mutant in the corpus fails it. One of two things: the
                     law is the base case of a step-rewriting generator, which
                     cannot produce a body that is right at the step and wrong
                     at the base -- the shape `04bc580` was written to find, and
                     the reason such a law is a check on the reference rather
                     than on the policy -- or the law is genuinely vacuous.
                     Eleven of these were the empty case across ten tasks.
  anchors flag       `tools.screens`'s reading: A and C are refusals in the
                     pipeline now, B is a target named on both sides of every
                     law naming it and is free up to a cancelling wrapper.
  general flag       no single law applies the target with every argument open,
                     so nothing reaches its recursive branch.
  no strong mutant   a corpus where every mutant dies at a value law and none at
                     the law that pins the shape.
  V1-V5 problem      the validator's own verdict, which is the one thing here
                     that is a defect rather than a reading.

V4 is deliberately not applied: the latency budget is a property of the task in
an episode, not of its laws, and running concurrently to keep this command
usable inflates the measurement it would be judging. The `--json` reading of
`tools.validate` is the place for it.

This writes nothing. In particular it does not write a review record -- it is
the input to one and must never be mistaken for the record itself.
"""

from __future__ import annotations

import argparse
import json
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.tasks import TaskError, load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain, ToolchainError  # noqa: E402
from gavel.validate import REVIEW_TIER, validate_task  # noqa: E402
from tools.screens import anchor_reports, general_flags  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent

# V4's budget, lifted out of the way. A reviewer is reading the laws; a task
# that is slow is a task to re-measure, not one to read differently, and the
# only honest latency reading is the serial one this command does not take.
NO_BUDGET_MS = 10 ** 9


def _flags(task, repo: Path) -> dict[str, list[str]]:
    """The static readings for one manifest-shaped row, as printable strings."""
    out: dict[str, list[str]] = {}
    for target, (code, why) in sorted(anchor_reports(task, repo).items()):
        out.setdefault("anchors", []).append(f"[{code}] {target}: {why}")
    for target, sigs in sorted(general_flags(task, repo).items()):
        out.setdefault("general", []).append(
            f"{target}: no law applies it with every argument open "
            f"({len(sigs)} application(s), all with a literal)")
    return out


def _block(row: dict, task, report) -> tuple[list[str], list[str]]:
    """(lines to print, findings) for one task."""
    tid = row["task_id"]
    lines = [f"{tid}  tier {task.tier}  "
             f"{'targets: ' + ', '.join(task.policy_targets) if task.policy_targets else 'no targets'}"]
    if report is None:
        lines.append(f"  laws      {', '.join(task.laws) or '(none)'}")
    else:
        if report.problems:
            lines.append(f"  PROBLEMS  {'; '.join(report.problems)}")
        kills = ", ".join(f"{law} {report.mutant_kills.get(law, 0)}"
                          for law in task.laws)
        lines.append(f"  kills     {kills or '(none)'}")
        strong = len(report.mutant_strong)
        lines.append(f"  corpus    {len(report.mutant_tiers)} mutants, "
                     f"{strong} strong, review {report.review}")

    findings: list[str] = []
    if report is not None:
        for law in task.laws:
            if report.mutant_kills.get(law, 0) == 0:
                findings.append(f"zero-kill law {law}")
        if report.problems:
            findings.extend(report.problems)

    flags = _flags(row, REPO_ROOT)
    for kind in ("anchors", "general"):
        for line in flags.get(kind, []):
            lines.append(f"  {kind:9s} {line}")
            findings.append(f"{kind}: {line.split(':')[0]}")
    if not flags:
        lines.append("  screens   clean")

    if not findings and report is not None and not report.mutant_strong:
        findings.append("no strong mutant")
    return lines, findings


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tasks", nargs="*", help="task ids; default is tier 3+")
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--tier", type=int, default=REVIEW_TIER,
                        help=f"lowest tier to docket (default {REVIEW_TIER})")
    parser.add_argument("--jobs", type=int, default=4,
                        help="tasks to run at once; safe here because V4 is not "
                             "applied, unlike tools.validate")
    parser.add_argument("--static", action="store_true",
                        help="skip the checker entirely; no kill counts")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    if args.tasks:
        try:
            rows = [(name, manifest.get(name)) for name in args.tasks]
        except TaskError as exc:
            # A typo must not read as a clean docket over zero tasks.
            print(f"docket: {exc}", file=sys.stderr)
            return 2
    else:
        rows = [(t.task_id, t) for t in manifest if t.tier >= args.tier]

    toolchain = None
    if not args.static:
        try:
            toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
        except ToolchainError as exc:
            print(f"docket: {exc}", file=sys.stderr)
            return 2

    def _one(pair):
        name, task = pair
        row = {"task_id": name,
               "path": task.root.relative_to(REPO_ROOT).as_posix()}
        report = (validate_task(task, toolchain, budget_ms=NO_BUDGET_MS)
                  if toolchain is not None else None)
        return _block(row, task, report)

    pairs = [(name, task) for name, task in rows]
    if args.jobs > 1 and len(pairs) > 1:
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            blocks = list(pool.map(_one, pairs))
    else:
        blocks = [_one(p) for p in pairs]

    shortlist = []
    for (name, task), (lines, findings) in zip(pairs, blocks):
        print("\n".join(lines))
        print()
        if findings:
            shortlist.append((name, task.tier, findings))

    print("=" * 72)
    if shortlist:
        print(f"SHORTLIST -- {len(shortlist)} of {len(pairs)} tasks have a finding, "
              f"most first. A finding is a place to look, not a defect:")
        # Most findings first, then the higher tier, then id: the reviewer reads
        # until the findings run out, so the order is the whole of the triage.
        for name, tier, findings in sorted(
                shortlist, key=lambda nf: (-len(nf[2]), -nf[1], nf[0])):
            print(f"  t{tier} {name:24s} {len(findings):2d}  {'; '.join(findings)}")
    else:
        print(f"SHORTLIST -- empty: no task at tier {args.tier}+ has a finding. "
              f"That is not the same as 'the laws are sound': nothing here runs a "
              f"body the laws were not written for, which is the reviewer's job.")
    print(f"\n{len(pairs)} tasks docketed"
          + ("; no checker runs" if args.static else f"; V4 not applied"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
