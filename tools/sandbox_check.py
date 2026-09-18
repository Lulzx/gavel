"""Prove the sandbox actually runs the checker, end to end.

``runner.BwrapBackend`` can be unit-tested for the shape of its argv, and that
test will pass on a machine where bubblewrap cannot create a user namespace --
which is the failure that matters, because it is silent: the check fails, the
reward is 0, and the transcript looks exactly like a policy that wrote bad
Bend. So the argument that CI should make is not "the flags are spelled right"
but "a check that works unsandboxed also works sandboxed".

    uv run python -m tools.sandbox_check          # auto: bwrap on Linux
    uv run python -m tools.sandbox_check --backend bwrap

Exits non-zero if the check does not pass, or if the two backends disagree.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from gavel.check import CheckConfig, check_submission  # noqa: E402
from gavel.runner import BackendError, select_backend  # noqa: E402
from gavel.tasks import PROOF_FILE, SOLUTION_FILE, load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.verdict import TIER_COMPLETE  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--task", default=None,
                        help="which task to check; the first one by default")
    parser.add_argument("--backend", default="auto",
                        help="auto, plain or bwrap")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
    task = manifest.get(args.task) if args.task else next(iter(manifest))

    try:
        backend = select_backend(args.backend)
    except BackendError as exc:
        print(f"FAIL: {exc}")
        return 2

    print(f"backend: {backend.name} (dev_only={backend.dev_only})")
    print(f"task:    {task.task_id}")

    files = {SOLUTION_FILE: task.reference_solution,
             PROOF_FILE: task.reference_proof}
    verdict = check_submission(task, toolchain, files,
                               CheckConfig(backend=backend.name))
    if verdict.tier != TIER_COMPLETE:
        print(f"FAIL: the reference solution scored tier {verdict.tier}, "
              f"not {TIER_COMPLETE}, under {backend.name}")
        for check in verdict.checks:
            print(f"  exit={check.exit_code} kind={check.failure_kind}")
            print("  " + (check.stderr or check.stdout).strip()[:500])
        return 1

    ran = {check.backend for check in verdict.checks}
    if ran != {backend.name}:
        print(f"FAIL: verdicts name {ran}, not {backend.name}")
        return 1
    if backend.name != "plain":
        print(f"OK: {verdict.reward} in {sum(c.ms for c in verdict.checks)} ms "
              f"of checker time, {len(verdict.checks)} run(s), sandboxed")
    else:
        print(f"OK: {verdict.reward} in {sum(c.ms for c in verdict.checks)} ms "
              f"of checker time, {len(verdict.checks)} run(s) -- NOT sandboxed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
