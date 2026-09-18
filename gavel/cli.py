"""Command line: check one submission, validate the bank, measure latency.

    gavel list [--tier N]
    gavel info TASK
    gavel check TASK --solution FILE --proof FILE
    gavel validate [TASK ...]
    gavel bench [TASK ...] [-n N]
"""

from __future__ import annotations

import argparse
import json
import statistics
import sys
import time
from pathlib import Path

from .check import CheckConfig, check_submission
from .laws import parse_imports, split_top_level
from .runner import run_check
from .tasks import (LAWS_FILE, PRELUDE_FILE, PROOF_FILE, SOLUTION_FILE,
                    load_manifest)
from .toolchain import DEFAULT_VERSION, Toolchain, ToolchainError
from .verdict import TIER_COMPLETE, Verdict

DEFAULT_MANIFEST = "manifest.json"
REPO_ROOT = Path(__file__).resolve().parent.parent

# V4: a task whose reference takes longer than this is too slow to train on.
REFERENCE_BUDGET_MS = 2000


def _load(args) -> tuple[Toolchain, object]:
    manifest = load_manifest(Path(args.manifest))
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
    return toolchain, manifest


def _tasks(manifest, names: list[str]) -> list:
    if not names:
        return list(manifest)
    out = []
    for name in names:
        out.append(manifest.get(name))
    return out


def cmd_list(args) -> int:
    _, manifest = _load(args)
    tasks = _tasks(manifest, args.tasks)
    if args.tier is not None:
        tasks = [t for t in tasks if t.tier == args.tier]
    if args.json:
        print(json.dumps([{"task_id": t.task_id, "tier": t.tier, "laws": list(t.laws),
                           "targets": list(t.policy_targets), "tags": list(t.tags),
                           "title": t.title} for t in tasks], indent=2))
        return 0
    by_tier: dict[int, list] = {}
    for task in tasks:
        by_tier.setdefault(task.tier, []).append(task)
    for tier in sorted(by_tier):
        print(f"tier {tier}: {len(by_tier[tier])} tasks")
        for task in by_tier[tier]:
            print(f"  {task.task_id:24s} {len(task.laws)} law(s)  "
                  f"{' '.join(task.tags)}")
    print(f"total: {len(tasks)}")
    return 0


def cmd_info(args) -> int:
    _, manifest = _load(args)
    task = manifest.get(args.task)
    print(f"task      {task.task_id} (tier {task.tier})")
    print(f"title     {task.title}")
    print(f"targets   {', '.join(task.policy_targets)}")
    print(f"laws      {', '.join(task.laws)}")
    print(f"weight    {task.difficulty_weight}")
    print(f"tags      {', '.join(task.tags)}")
    print(f"hash      {task.hash}")
    print(f"reference {task.references}")
    print("\n--- prompt.md ---")
    print(task.prompt.strip())
    print("\n--- LAWS.bend ---")
    print(task.laws_src.strip())
    print("\n--- solution.bend (stub) ---")
    print(task.stub_src.strip())
    return 0


def cmd_check(args) -> int:
    toolchain, manifest = _load(args)
    task = manifest.get(args.task)
    files = {}
    if args.solution:
        files[SOLUTION_FILE] = Path(args.solution).read_text()
    else:
        files[SOLUTION_FILE] = task.stub_src
    if args.proof:
        files[PROOF_FILE] = Path(args.proof).read_text()
    else:
        files[PROOF_FILE] = task.proof_header
    if args.reference:
        files[SOLUTION_FILE] = task.reference_solution
        files[PROOF_FILE] = task.reference_proof

    verdict = check_submission(task, toolchain, files, CheckConfig())
    _print_verdict(verdict, args.json)
    return 0 if verdict.tier > 0 else 1


def _print_verdict(verdict: Verdict, as_json: bool) -> None:
    if as_json:
        print(json.dumps(verdict.to_json(), indent=2))
        return
    print(f"{verdict.task_id}: tier {verdict.tier} ({verdict.tier_name}) "
          f"reward {verdict.reward:.3f}")
    if verdict.gate and not verdict.gate.ok:
        for finding in verdict.gate.findings:
            print(f"  gate: {finding}")
    if verdict.proven:
        print(f"  proven: {', '.join(verdict.proven)}")
    if verdict.failed:
        print(f"  failed: {', '.join(verdict.failed)}")
    for i, result in enumerate(verdict.checks):
        print(f"  run {i}: {result.failure_kind} exit={result.exit_code} "
              f"{result.ms}ms")
        if not result.ok:
            for line in result.feedback(600).splitlines():
                print(f"    | {line}")
    print(f"  {verdict.ms}ms total, {len(verdict.checks)} checker run(s)")


def cmd_validate(args) -> int:
    """V1, V4, V5 of SPEC.md 5.5. V2 and V3 arrive with the mutant pipeline.

    V2 is a warning until the mutant corpus exists: a missing mutant is not a
    defect in the task, but it does mean the task's laws are unguarded against
    a degenerate proof, so it must not pass silently forever. --strict promotes
    it, and M1 flips the default once every task has mutants.
    """
    toolchain, manifest = _load(args)
    tasks = _tasks(manifest, args.tasks)
    failures: list[str] = []
    reports = []
    for task in tasks:
        report = _validate_task(task, toolchain)
        if args.strict and report["warnings"]:
            report["problems"].extend(report["warnings"])
            report["warnings"] = []
        report["valid"] = not report["problems"]
        reports.append(report)
        if not report["valid"]:
            failures.append(task.task_id)
        if not args.json:
            notes = report["problems"] or report["warnings"]
            status = "ok  " if report["valid"] else "FAIL"
            print(f"[{status}] {task.task_id:24s} tier {task.tier}  "
                  f"{report['reference_ms']}ms  "
                  f"{' '.join(notes) or 'V1,V4,V5 pass'}")
    if args.json:
        print(json.dumps(reports, indent=2))
    print(f"\n{len(tasks) - len(failures)}/{len(tasks)} tasks valid")
    return 1 if failures else 0


def _validate_task(task, toolchain: Toolchain) -> dict:
    problems: list[str] = []
    warnings: list[str] = []
    files = {SOLUTION_FILE: task.reference_solution, PROOF_FILE: task.reference_proof}
    verdict = check_submission(task, toolchain, files, CheckConfig())

    # V1: the reference proves every law.
    if verdict.tier != TIER_COMPLETE:
        problems.append(f"V1: reference is tier {verdict.tier}, not 4, "
                        f"({verdict.tier_name})")
    # V4: the reference checks inside the latency budget.
    reference_ms = max((c.ms for c in verdict.checks), default=0)
    if reference_ms > REFERENCE_BUDGET_MS:
        problems.append(f"V4: reference took {reference_ms}ms > {REFERENCE_BUDGET_MS}ms")
    # V5: the task's own files carry no forbidden construct.
    for name, text in ((LAWS_FILE, task.laws_src), (PRELUDE_FILE, task.prelude_src)):
        for chunk in split_top_level(text):
            if chunk.unsafe:
                problems.append(f"V5: {name} uses @unsafe (line {chunk.line})")
        for imp in _task_imports(text):
            problems.append(f"V5: {name} has a disallowed import ({imp})")
    if not task.mutant_paths:
        warnings.append("V2: no mutants authored")

    return {"task_id": task.task_id, "tier": task.tier, "valid": not problems,
            "problems": problems, "warnings": warnings, "reference_ms": reference_ms,
            "laws": list(task.laws), "hash": task.hash,
            "zero_shot_solve_rate": task.meta.get("zero_shot_solve_rate")}


def _task_imports(text: str) -> list[str]:
    allowed = {"Base", f"./{LAWS_FILE}", f"./{PRELUDE_FILE}", f"./{SOLUTION_FILE}"}
    return [imp.path for imp in parse_imports(text) if imp.path not in allowed]


def cmd_bench(args) -> int:
    toolchain, manifest = _load(args)
    tasks = _tasks(manifest, args.tasks)
    samples: list[float] = []
    verdicts = []
    for _ in range(args.n):
        for task in tasks:
            files = {SOLUTION_FILE: task.reference_solution,
                     PROOF_FILE: task.reference_proof}
            started = time.monotonic()
            verdict = check_submission(task, toolchain, files, CheckConfig())
            samples.append((time.monotonic() - started) * 1000)
            verdicts.append(verdict)
    samples.sort()

    def pct(p: float) -> float:
        return samples[min(len(samples) - 1, int(len(samples) * p))]

    report = {
        "runs": len(samples),
        "p50_ms": round(statistics.median(samples), 1),
        "p95_ms": round(pct(0.95), 1),
        "p99_ms": round(pct(0.99), 1),
        "min_ms": round(samples[0], 1),
        "max_ms": round(samples[-1], 1),
        "checks_per_verdict": round(
            statistics.mean(len(v.checks) for v in verdicts), 2),
        "toolchain_hash": toolchain.tree_hash,
        "tasks": [t.task_id for t in tasks],
    }
    print(json.dumps(report, indent=2))
    return 0


def cmd_checker(args) -> int:
    """Run the pinned checker directly on a directory. A debugging aid."""
    toolchain, _ = _load(args)
    workdir = Path(args.dir)
    result = run_check(toolchain, workdir, args.target)
    print(json.dumps(result.to_json(), indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="gavel", description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--manifest", default=str(REPO_ROOT / DEFAULT_MANIFEST))
    sub = parser.add_subparsers(dest="command", required=True)

    p_list = sub.add_parser("list", help="list tasks in the bank")
    p_list.add_argument("tasks", nargs="*")
    p_list.add_argument("--tier", type=int)
    p_list.add_argument("--json", action="store_true")
    p_list.set_defaults(func=cmd_list)

    p_info = sub.add_parser("info", help="show one task")
    p_info.add_argument("task")
    p_info.set_defaults(func=cmd_info)

    p_check = sub.add_parser("check", help="check a submission against a task")
    p_check.add_argument("task")
    p_check.add_argument("--solution", help="solution.bend to submit")
    p_check.add_argument("--proof", help="PROOF.bend to submit")
    p_check.add_argument("--reference", action="store_true",
                         help="use the task's hidden reference")
    p_check.add_argument("--json", action="store_true")
    p_check.set_defaults(func=cmd_check)

    p_val = sub.add_parser("validate", help="check a task's validity invariants")
    p_val.add_argument("tasks", nargs="*")
    p_val.add_argument("--json", action="store_true")
    p_val.add_argument("--strict", action="store_true",
                       help="treat warnings (missing mutants) as failures")
    p_val.set_defaults(func=cmd_validate)

    p_bench = sub.add_parser("bench", help="measure check latency")
    p_bench.add_argument("tasks", nargs="*")
    p_bench.add_argument("-n", type=int, default=5, help="repetitions")
    p_bench.set_defaults(func=cmd_bench)

    p_chk = sub.add_parser("checker", help="run the pinned checker on a directory")
    p_chk.add_argument("dir")
    p_chk.add_argument("target", nargs="?", default=PROOF_FILE)
    p_chk.set_defaults(func=cmd_checker)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        return args.func(args)
    except ToolchainError as exc:
        print(f"gavel: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
