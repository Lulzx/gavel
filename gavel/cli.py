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
from .runner import run_check
from .tasks import PROOF_FILE, SOLUTION_FILE, load_manifest
from .toolchain import DEFAULT_VERSION, Toolchain, ToolchainError
from .validate import validate_task
from .verdict import Verdict

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

    verdict = check_submission(task, toolchain, files,
                               CheckConfig(backend=args.backend))
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
    """SPEC.md 5.5. The invariants themselves live in gavel/validate.py."""
    toolchain, manifest = _load(args)
    tasks = _tasks(manifest, args.tasks)
    reports = [validate_task(task, toolchain, budget_ms=REFERENCE_BUDGET_MS,
                             strict=args.strict) for task in tasks]

    if args.json:
        print(json.dumps([r.to_json() for r in reports], indent=2))
    else:
        for report in reports:
            notes = report.problems or report.warnings
            status = "ok  " if report.valid else "FAIL"
            print(f"[{status}] {report.task_id:24s} tier {report.tier}  "
                  f"{report.reference_ms}ms  "
                  f"{' '.join(notes) or 'V1,V4,V5 pass'}")
    failures = [r for r in reports if not r.valid]
    print(f"\n{len(reports) - len(failures)}/{len(reports)} tasks valid")
    return 1 if failures else 0


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


def cmd_serve(args) -> int:
    """Serve the episode protocol. Blocks until interrupted."""
    from . import server as server_mod

    if not args.socket and not args.http:
        args.socket = "gavel.sock"
    gavel = server_mod.GavelServer.from_manifest(
        Path(args.manifest), mode=args.mode, max_turns=args.max_turns,
        backend=args.backend,
        cache=server_mod.VerdictCache(args.cache) if args.cache else None,
        trajectory=(server_mod.Trajectory(args.trajectory, run_id=args.run_id)
                    if args.trajectory else None))
    http = None
    if args.http:
        host, _, port = args.http.rpartition(":")
        http = (host or "127.0.0.1", int(port or 8765))
    where = ", ".join(filter(None, [args.socket and f"unix:{args.socket}",
                                    http and f"http://{http[0]}:{http[1]}"]))
    print(f"gavel serving {len(gavel.manifest)} tasks on {where}", flush=True)
    server_mod.serve(socket_path=args.socket, http=http, gavel=gavel)
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
    p_check.add_argument("--backend", default="auto",
                         choices=("auto", "plain", "bwrap"),
                         help="process isolation; auto picks bwrap on Linux")
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

    p_srv = sub.add_parser("serve", help="serve the episode protocol over a socket")
    p_srv.add_argument("--socket", default=None,
                       help="Unix socket path (default gavel.sock)")
    p_srv.add_argument("--http", default=None,
                       help="host:port to bind, loopback by default")
    p_srv.add_argument("--mode", default="dense", choices=("dense", "sparse"))
    p_srv.add_argument("--max-turns", type=int, default=4)
    p_srv.add_argument("--backend", default="auto",
                       choices=("auto", "plain", "bwrap"))
    p_srv.add_argument("--cache", default=None, help="sqlite verdict cache path")
    p_srv.add_argument("--trajectory", default=None, help="JSONL episode log path")
    p_srv.add_argument("--run-id", default=None, help="name this run in the log")
    p_srv.set_defaults(func=cmd_serve)
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
