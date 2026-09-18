"""Measure zero-shot solve rate: k attempts per task, no human in the loop.

    uv run python -m tools.calibrate t1-add-plus -k 5
    uv run python -m tools.calibrate -k 3 --model claude-opus-5
    uv run python -m tools.calibrate --dry-run          # prompt only, no spend
    uv run python -m tools.calibrate -k 5 --write-meta  # record on the tasks

The number this produces is M0's exit criterion: a bank whose tasks a frontier
model solves every time teaches nothing, and one it never solves is guesswork
rather than learning. PLAN.md wants 10-60%.

``--dry-run`` prints one assembled prompt and exits. Nothing is spent, and the
observation plumbing is exercised without a key.
"""

from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.env import GavelEnv  # noqa: E402
from gavel.policy import (DEFAULT_MODEL, AnthropicPolicy, EchoPolicy,  # noqa: E402
                          PolicyError, build_prompt)
from gavel.tasks import load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.verdict import TIER_COMPLETE  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent


def run_task(env: GavelEnv, policy, task_id: str, turns: int) -> dict:
    """One attempt: reset, then up to ``turns`` submissions with feedback.

    Each turn is a fresh submission against the same task; the only thing that
    carries over is the checker's own error text. ``env`` must be built with
    ``max_turns >= turns`` or the last step raises.
    """
    observation = env.reset(task_id)
    reward, verdict = 0.0, None
    for _ in range(turns):
        try:
            action = policy(observation)
        except PolicyError as exc:
            return {"task_id": task_id, "solved": False, "tier": 0,
                    "reward": 0.0, "turns": env.turn, "error": str(exc)}
        observation, reward, done, verdict = env.step(action)
        if done:
            break
    return {"task_id": task_id, "solved": verdict.tier == TIER_COMPLETE,
            "tier": verdict.tier, "reward": reward, "turns": env.turn,
            "error": None}


def summarise(attempts: list[dict], k: int) -> dict:
    per_task: dict[str, list[dict]] = {}
    for attempt in attempts:
        per_task.setdefault(attempt["task_id"], []).append(attempt)
    rates = {task_id: sum(a["solved"] for a in rows) / len(rows)
             for task_id, rows in per_task.items()}
    overall = sum(a["solved"] for a in attempts) / len(attempts) if attempts else 0.0
    return {
        "attempts": len(attempts),
        "k": k,
        "zero_shot_solve_rate": round(overall, 4),
        "per_task": {task_id: round(rate, 4) for task_id, rate in sorted(rates.items())},
        "tiers": sorted(a["tier"] for a in attempts),
        "median_reward": round(statistics.median([a["reward"] for a in attempts]), 4)
                         if attempts else 0.0,
        "errors": [a["error"] for a in attempts if a["error"]],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tasks", nargs="*", help="task ids; default is all")
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("-k", type=int, default=5, help="attempts per task")
    parser.add_argument("--turns", type=int, default=1,
                        help="turns per attempt; >1 feeds the checker's error back")
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--echo", action="store_true",
                        help="use the stub as the answer, to sanity-check the floor")
    parser.add_argument("--dry-run", action="store_true",
                        help="print one prompt and exit without calling the model")
    parser.add_argument("--write-meta", action="store_true",
                        help="record zero_shot_solve_rate on each task")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args(argv)
    if args.k < 1 or args.turns < 1:
        parser.error("-k and --turns must be at least 1")

    manifest = load_manifest(Path(args.manifest))
    tasks = [manifest.get(name) for name in args.tasks] if args.tasks else list(manifest)
    if not tasks:
        print("calibrate: the bank is empty", file=sys.stderr)
        return 2

    if args.dry_run:
        toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
        env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=args.seed)
        print(build_prompt(env.reset(tasks[0].task_id)))
        return 0

    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=args.seed,
                   max_turns=args.turns)
    policy = EchoPolicy() if args.echo else AnthropicPolicy(
        model=args.model, temperature=args.temperature)

    attempts = []
    try:
        for task in tasks:
            for _ in range(args.k):
                attempt = run_task(env, policy, task.task_id, args.turns)
                attempts.append(attempt)
                if not args.json:
                    mark = "solved" if attempt["solved"] else f"tier {attempt['tier']}"
                    print(f"  {task.task_id:24s} {mark}")
    except PolicyError as exc:
        print(f"calibrate: {exc}", file=sys.stderr)
        return 2
    finally:
        env.close()

    report = summarise(attempts, args.k)
    report["model"] = policy.name if args.echo else args.model
    report["turns"] = args.turns
    report["temperature"] = args.temperature
    if not args.echo:
        report["input_tokens"] = policy.input_tokens
        report["output_tokens"] = policy.output_tokens
        report["api_calls"] = policy.calls

    if args.write_meta:
        for task_id, rate in report["per_task"].items():
            meta_path = manifest.get(task_id).root / "meta.json"
            meta = json.loads(meta_path.read_text())
            meta["zero_shot_solve_rate"] = rate
            meta_path.write_text(json.dumps(meta, indent=2) + "\n")
        print(f"recorded zero_shot_solve_rate on {len(report['per_task'])} task(s)")

    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
