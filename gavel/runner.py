"""Running the pinned checker on one file, once.

One check is one subprocess: fresh working directory, scrubbed environment,
resource limits, a wall clock, and a hard cap on output. The output parser is
the part that carries the reward, so it is deliberately literal -- see
``CheckResult`` for why the exit code alone is not a signal.
"""

from __future__ import annotations

import os
import re
import resource
import signal
import subprocess
import time
from dataclasses import dataclass
from pathlib import Path

from .toolchain import Toolchain
from .verdict import CheckResult

# The exact sentence printed when the checker has accepted every term
# (main.ts:402). Success is this string and nothing else: a file carrying
# @unsafe exits 0 while printing a warning instead, and a file declaring main
# exits 0 while printing that program's output instead.
SUCCESS_LINE = "All terms check."

# main.ts:401
UNSAFE_MARK = "annotated as unsafe"

# main.ts:434, printed to stderr.
_TODO = re.compile(r"^Error: (\d+) TODOs? found\.", re.MULTILINE)

# err_show (bend.ts:1470) ends every diagnostic with a Location line naming the
# def being checked, which is what lets a per-law run attribute a failure.
_LOCATION = re.compile(r"^Location:\s*(.+?)\s*$", re.MULTILINE)


@dataclass(frozen=True)
class Limits:
    wall_ms: int = 10_000
    memory_bytes: int = 2 * 1024 ** 3
    nproc: int | None = None
    """Left unset on purpose.

    RLIMIT_NPROC counts the *user's* processes, not the check's, so an absolute
    cap silently makes the checker unable to fork on any machine that is
    already busy -- measured here at 447 processes for the user against a cap
    of 64, which failed every check with "fork: Resource temporarily
    unavailable". Bend cannot spawn processes, so this was never the boundary
    that mattered; the wall clock, the memory ceiling, and the Linux sandbox
    are. A deployment with cgroup pids limits should set this to a headroom
    above the expected process count rather than to a constant.
    """

    cpu_seconds: int = 30
    output_bytes: int = 64 * 1024


DEFAULT_LIMITS = Limits()

# An unroutable address: a hub fetch must fail immediately rather than hang or
# reach the network. The gate forbids hub imports as well; this is the layer
# that still holds if the gate is ever wrong.
BLOCKED_HUB = "http://127.0.0.1:9"


def scrub_env(workdir: Path, bun: Path) -> dict[str, str]:
    """The whole environment the checker gets. Nothing is inherited."""
    return {
        "PATH": str(bun.parent),
        "HOME": str(workdir),
        "TMPDIR": str(workdir),
        "BEND_HUB": BLOCKED_HUB,
        "BEND_LIB": str(workdir / ".bend" / "lib"),
        "BEND_NO_TELEMETRY": "1",
        "LANG": "C",
        "LC_ALL": "C",
    }


def run_check(toolchain: Toolchain, workdir: Path, target: str,
              limits: Limits = DEFAULT_LIMITS) -> CheckResult:
    """Check ``target`` (a name inside ``workdir``) with the pinned checker."""
    workdir = Path(workdir)
    stdout_path = workdir / ".gavel.stdout"
    stderr_path = workdir / ".gavel.stderr"
    argv = toolchain.argv(target)
    began = time.monotonic()

    with open(stdout_path, "wb") as out, open(stderr_path, "wb") as err:
        try:
            proc = subprocess.Popen(
                argv, cwd=workdir, env=scrub_env(workdir, toolchain.bun),
                stdout=out, stderr=err, stdin=subprocess.DEVNULL,
                start_new_session=True,
                preexec_fn=_limit(limits) if os.name == "posix" else None,
            )
        except OSError as exc:
            return CheckResult(ok=False, exit_code=None,
                               ms=int((time.monotonic() - began) * 1000),
                               stderr=f"could not start the checker: {exc}")

        timed_out = False
        try:
            exit_code = proc.wait(timeout=limits.wall_ms / 1000)
        except subprocess.TimeoutExpired:
            timed_out = True
            _kill_group(proc)
            exit_code = None

    ms = int((time.monotonic() - began) * 1000)
    stdout = _read_capped(stdout_path, limits.output_bytes)
    stderr = _read_capped(stderr_path, limits.output_bytes)
    stdout_path.unlink(missing_ok=True)
    stderr_path.unlink(missing_ok=True)

    success = stdout.strip() == SUCCESS_LINE
    unsafe = UNSAFE_MARK in stdout or UNSAFE_MARK in stderr
    todo = _TODO.search(stderr)
    location = _LOCATION.search(stderr)
    error_block = stderr.strip() if stderr.lstrip().startswith("Error") else None

    return CheckResult(
        ok=(exit_code == 0 and success and not unsafe and not timed_out),
        exit_code=exit_code,
        ms=ms,
        success_line=success,
        unsafe_warning=unsafe,
        todo_count=int(todo.group(1)) if todo else None,
        timed_out=timed_out,
        error_block=error_block,
        error_location=location.group(1) if location else None,
        stdout=stdout,
        stderr=stderr,
    )


def _limit(limits: Limits):
    """Apply rlimits in the child, after fork and before exec."""
    def apply() -> None:
        _set(resource.RLIMIT_CPU, limits.cpu_seconds)
        if limits.nproc is not None:
            _set(resource.RLIMIT_NPROC, limits.nproc)
        # RLIMIT_AS is enforced on Linux and ignored on Darwin; setting it is
        # free either way, and the memory ceiling matters on the Linux backend.
        _set(resource.RLIMIT_AS, limits.memory_bytes)
        _set(resource.RLIMIT_CORE, 0)
        _set(resource.RLIMIT_FSIZE, limits.output_bytes)
    return apply


def _set(which: int, value: int) -> None:
    try:
        soft, hard = resource.getrlimit(which)
        ceiling = value if hard == resource.RLIM_INFINITY else min(value, hard)
        resource.setrlimit(which, (ceiling, hard))
    except (ValueError, OSError):
        pass


def _kill_group(proc: subprocess.Popen) -> None:
    """Kill the checker and anything it spawned.

    bun starts in its own session, so signals to the group reach the workers it
    may have forked. A non-terminating @unsafe recursion is not hypothetical:
    it hangs the checker with no output at all.
    """
    for sig in (signal.SIGKILL,):
        try:
            os.killpg(os.getpgid(proc.pid), sig)
        except (ProcessLookupError, PermissionError, OSError):
            pass
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        pass


def _read_capped(path: Path, limit: int) -> str:
    try:
        with open(path, "rb") as handle:
            blob = handle.read(limit + 1)
    except OSError:
        return ""
    if len(blob) > limit:
        return blob[:limit].decode("utf-8", errors="replace") + "\n... (truncated)"
    return blob.decode("utf-8", errors="replace")
