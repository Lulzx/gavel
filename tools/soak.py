"""M3 item 5: run the bank unattended, and report what it cost.

    uv run python -m tools.soak --episodes 10000 --jobs 8 --out runs/soak
    uv run python -m tools.soak --episodes 2000 --policy scripted   # the cache

M3's exit criterion is that an external RL loop runs ten thousand episodes
unattended. This stands in for that loop with a *scripted* policy -- one that
emits attempts from the task's own repertoire rather than from a model -- so
that what the run exercises is the harness and not the policy: episode
lifecycle, dense reward, the per-law fixed point, the gate, the cache, the log,
and the metrics.

Two properties make the numbers mean something.

**An episode is a function of its index.** The task and the script come from
``Random(seed + index)``, never from a clock or a thread, so the same seed
produces the same ten thousand episodes at any ``--jobs``. A soak whose
contents depend on how it was parallelised cannot be compared to a re-run of
itself, which is the only comparison a soak is for.

**``--policy`` decides what is being measured.** ``noisy`` (the default) marks
each submission so that no two are byte-identical: every turn is a real
checker run, and the latency percentiles are the checker's. ``scripted``
re-sends identical bytes, so after the repertoire is warm almost every turn is
a cache hit and the run measures the cache and the harness around it. The
report says which one it was.
"""

from __future__ import annotations

import argparse
import json
import queue
import random
import resource
import sys
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.cache import VerdictCache  # noqa: E402
from gavel.degenerate import corpus  # noqa: E402
from gavel.env import (DEFAULT_MAX_TURNS, Action, GavelEnv, Sampler,  # noqa: E402
                       tier_sampler, uniform_sampler)
from gavel.metrics import Metrics, summarise  # noqa: E402
from gavel.tasks import (PROOF_FILE, SOLUTION_FILE, Manifest,  # noqa: E402
                         Task, load_manifest)
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.trajectory import Trajectory  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent

# The three things a scripted policy does. A climb ends in the reference
# solution and is the only family that can reach tier 4; a fail re-submits
# mutants and never does; a gate trips the gate, which is the tier-0 path and
# the one the checker alone does not enforce (``@unsafe`` exits 0).
CLIMB, FAIL, GATE = "climb", "fail", "gate"

# Roughly how a policy behaves early in training, and enough of each family to
# make every tier appear in the histogram. Deliberately not tuned: a soak that
# reported a flattering solve rate would be reporting on the script.
FAMILIES: tuple[tuple[str, float], ...] = (
    (CLIMB, 0.50),
    (FAIL, 0.40),
    (GATE, 0.10),
)

# How often a climb gets there on the first try. Not a difficulty claim -- a
# soak is not a benchmark -- but enough that early termination is sampled.
EARLY_SOLVE = 0.15


@dataclass(frozen=True)
class Attempt:
    """One submission, and what it is for."""

    name: str
    files: dict[str, str]


def repertoire(task: Task) -> dict[str, list[Attempt]]:
    """The attempts a scripted policy can make on this task.

    Built from the task rather than written by hand, from the same generators
    V3 uses: if the corpus is wrong the soak inherits the error, and the two
    disagreeing is itself worth finding out.
    """
    made = {a.name: a.files for a in corpus(task)}
    reference = Attempt("reference", {SOLUTION_FILE: task.reference_solution,
                                      PROOF_FILE: task.reference_proof})
    climb = [Attempt("no-proof", made["reference+no-proof"]),
             Attempt("holed-proof", made["reference+holed-proof"]),
             reference]
    fail = [Attempt(f"mutant:{path.stem}",
                    {SOLUTION_FILE: path.read_text(),
                     PROOF_FILE: task.reference_proof})
            for path in task.mutant_paths]
    gate = [Attempt("self-referential-unsafe",
                    made["self-referential-unsafe"])]
    return {CLIMB: climb, FAIL: fail or climb[:-1], GATE: gate}


def choose(rng: random.Random,
           families: tuple[tuple[str, float], ...] = FAMILIES) -> str:
    pick = rng.random()
    running = 0.0
    for name, weight in families:
        running += weight
        if pick < running:
            return name
    return families[-1][0]


def script(task: Task, family: str, max_turns: int,
           rng: random.Random) -> list[Attempt]:
    """The attempts for one episode, the last of which ends it.

    A climb ends on the reference, so its length is where the policy finally
    got there -- not always the turn budget. Most climbs take the whole
    episode, but a policy that has already learned a task solves it early, and
    ``done`` before the budget is spent is a distinct path through
    :meth:`GavelEnv.step` that a soak of nothing but full-length episodes
    would never touch.

    Everything else runs to the budget, because nothing else can solve: an
    episode that stops for any other reason is one the env has to end on the
    next ``reset``, logged as an episode that ended for a reason the script
    did not intend.
    """
    pool = repertoire(task)[family]
    if family != CLIMB:
        return [pool[i % len(pool)] for i in range(max_turns)]
    rungs = pool[:-1] or pool
    # A one-turn episode has one turn to solve in, so there is nothing to
    # decide -- and ``randint(2, 1)`` is an empty range, not a small one.
    at = 1 if max_turns == 1 or rng.random() < EARLY_SOLVE \
        else rng.randint(2, max_turns)
    return [rungs[i % len(rungs)] for i in range(at - 1)] + [pool[-1]]


def jitter(files: dict[str, str], nonce: int) -> dict[str, str]:
    """Different bytes, same program.

    A comment on the end of each file, so the cache key changes and the verdict
    cannot. Without this a scripted policy over a fixed repertoire is a
    hundred distinct checks repeated ten thousand times, and the run says
    nothing about how long a *check* takes.
    """
    mark = f"\n# soak {nonce}\n"
    return {name: text + mark for name, text in files.items()}


@dataclass
class Soak:
    """One unattended run. Owns nothing it did not create."""

    manifest: Manifest
    toolchain: Toolchain
    sampler: Sampler = uniform_sampler
    episodes: int = 10_000
    seed: int = 0
    max_turns: int = DEFAULT_MAX_TURNS
    mode: str = "dense"
    policy: str = "noisy"
    jobs: int = 1
    backend: str | None = None

    cache: VerdictCache | None = None
    """Shared across workers. Not owned: the caller closes it, and a run that
    warmed it should leave it warm."""

    trajectory: Trajectory | None = None
    """Shared across workers, and closed by the caller -- see ``_env``."""

    metrics: Metrics = field(default_factory=Metrics)
    _count: int = field(default=0, init=False, repr=False)
    families: dict[int, str] = field(default_factory=dict, init=False, repr=False)
    """Which family each episode index drew. The report needs it to tell an
    incident the soak asked for from one it did not: the ``fail`` family
    submits mutants on purpose, and ``check.py`` withholds the reward of any
    submission byte-identical to one of them that reaches a proving tier."""

    _lock: threading.Lock = field(default_factory=threading.Lock,
                                  init=False, repr=False)

    def _env(self) -> GavelEnv:
        """A private env per worker, sharing the log and the report.

        ``close()`` is deliberately never called on these: it closes the
        trajectory, and the trajectory belongs to the run. Nothing else leaks
        from it -- every episode the worker starts it also finishes, so there
        is no open episode for ``close()`` to end.
        """
        env = GavelEnv(manifest=self.manifest, toolchain=self.toolchain,
                       mode=self.mode, max_turns=self.max_turns,
                       cache=self.cache, seed=self.seed, backend=self.backend)
        env.trajectory = self.trajectory
        env.metrics = self.metrics
        return env

    def run_episode(self, env: GavelEnv, index: int) -> None:
        rng = random.Random(self.seed + index)
        task = self.sampler(self.manifest, rng)
        env.reset(task.task_id)
        # The log's episode number has to be unique across workers, and each
        # env counts only its own. ``episodes`` is read once per episode, at
        # the end, so setting it here stamps this record with the index of the
        # episode rather than of the worker.
        env.episodes = index
        family = choose(rng)
        with self._lock:
            self.families[index] = family
        for turn, attempt in enumerate(script(task, family, self.max_turns, rng)):
            # The nonce is per *turn*, not per episode: a rung the script
            # repeats would otherwise hit the entry its own first submission
            # wrote, and "noisy" would not mean every turn was a real check.
            files = jitter(attempt.files, index * self.max_turns + turn) \
                if self.policy == "noisy" else attempt.files
            _, _, done, _ = env.step(Action(dict(files)))
            if done:
                return
        raise AssertionError(
            f"episode {index} on {task.task_id} spent {self.max_turns} turns "
            f"without ending; the script and max_turns disagree")

    def run(self, on_episode: Callable[[int], None] | None = None) -> Metrics:
        """Drive every episode, on ``jobs`` threads, and return the report.

        The first exception from a worker is re-raised here rather than being
        swallowed: a soak that quietly ran nine thousand of its ten thousand
        episodes would report a distribution of the nine thousand.
        """
        work: queue.Queue[int] = queue.Queue()
        for index in range(self.episodes):
            work.put(index)
        failures: list[BaseException] = []

        def worker() -> None:
            env = self._env()
            while True:
                try:
                    index = work.get_nowait()
                except queue.Empty:
                    return
                try:
                    self.run_episode(env, index)
                except BaseException as exc:      # noqa: BLE001 - re-raised below
                    failures.append(exc)
                    return
                finally:
                    work.task_done()
                with self._lock:
                    self._count += 1
                    count = self._count
                if on_episode is not None:
                    on_episode(count)

        threads = [threading.Thread(target=worker, name=f"soak-{n}", daemon=True)
                   for n in range(max(1, self.jobs))]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        if failures:
            raise failures[0]
        return self.metrics


# --- reporting -----------------------------------------------------------------

def child_cpu_s() -> float:
    """CPU seconds this process's reaped children have consumed so far.

    ``RUSAGE_CHILDREN`` is cumulative and process-wide, so the useful reading is
    a delta around the run rather than a per-check one. That is also what makes
    it the one throughput number a contended host cannot corrupt: wall clock
    measures how long the verdict waited, which includes every other process on
    the box, while this measures the work the verdict did. The only children a
    soak spawns are checker processes, so the delta is the checker's.
    """
    usage = resource.getrusage(resource.RUSAGE_CHILDREN)
    return usage.ru_utime + usage.ru_stime


def throughput(metrics: Metrics, elapsed_s: float, jobs: int,
               cpu_s: float | None = None) -> dict[str, float]:
    """Verdicts per minute, and per minute per core.

    "Core" is the worker thread count, which is the honest denominator for a
    run whose workers are blocked on a subprocess: the interesting number is
    how much of what was paid for was used.

    ``cpu_s`` adds the reading that survives a busy machine -- verdicts per
    minute of *checker CPU* -- so a host that cannot be quieted still yields a
    publishable rate, and the two numbers disagreeing is itself the measurement
    of how contended the host was.

    ``cpu_amplification`` is checker CPU per CPU-second of worker budget. Above
    1 is normal and is not an error: the checker is `bun`, so one verdict forks
    and threads on its own, and a run of 8 workers can spend 9 cores' worth of
    CPU. It is the number that says how much of the wall clock a worker was
    actually working through, and it is the reason ``verdicts_per_cpu_min`` is
    lower than ``verdicts_per_min_per_core * 60``.
    """
    minutes = elapsed_s / 60.0 if elapsed_s > 0 else 0.0
    cores = max(1, jobs)
    per_min = metrics.turns / minutes if minutes else 0.0
    report = {
        "verdicts_per_min": round(per_min, 1),
        "verdicts_per_min_per_core": round(per_min / cores, 1),
        "episodes_per_min": round(metrics.episodes / minutes, 1) if minutes else 0.0,
        "elapsed_s": round(elapsed_s, 2),
        "jobs": cores,
    }
    if cpu_s is not None:
        cpu_minutes = cpu_s / 60.0
        report["checker_cpu_s"] = round(cpu_s, 2)
        report["ms_per_verdict_cpu"] = (
            round(cpu_s * 1000 / metrics.turns, 1) if metrics.turns else 0.0)
        report["verdicts_per_cpu_min"] = (
            round(metrics.turns / cpu_minutes, 1) if cpu_minutes > 0 else 0.0)
        report["cpu_amplification"] = (
            round(cpu_s / (elapsed_s * cores), 3) if elapsed_s > 0 else 0.0)
    return report


def audit(trajectory: Trajectory, live: Metrics,
          families: dict[int, str]) -> dict:
    """Read the log back, and say where it disagrees with the live run.

    ``metrics.py`` claims that a run watched live and the same run read back
    afterwards cannot disagree, because both are derived from the same records.
    At ten thousand episodes that is worth checking rather than asserting, and
    the check is free: the log has to be read anyway to attribute the
    incidents, which are the one counter whose *expected* value depends on
    what the script did rather than on what the harness did.
    """
    replayed = Metrics()
    incidents: dict[str, int] = {}
    for episode in trajectory.read():
        replayed.add(episode)
        count = sum(1 for turn in episode.turns
                    if turn.verdict.incident is not None)
        if count:
            family = families.get(episode.episode, "unknown")
            incidents[family] = incidents.get(family, 0) + count
    return {
        "replayed": replayed,
        "incidents_by_family": incidents,
        "incidents_unexpected": sum(count for family, count in incidents.items()
                                    if family != FAIL),
        "disagreements": _disagreements(live.to_json(), replayed.to_json()),
    }


def _disagreements(live: dict, logged: dict) -> list[str]:
    return [f"{key}: the run says {value!r}, the log says {logged.get(key)!r}"
            for key, value in live.items() if logged.get(key) != value]


def build_report(soak: Soak, metrics: Metrics, elapsed_s: float,
                 run_id: str, logged: dict, cpu_s: float | None = None) -> dict:
    blob = metrics.to_json()
    return {
        "incidents_by_family": logged["incidents_by_family"],
        "incidents_unexpected": logged["incidents_unexpected"],
        "replay_disagreements": logged["disagreements"],
        "families": {name: sum(1 for f in soak.families.values() if f == name)
                     for name, _ in FAMILIES},
        "run_id": run_id,
        "bank_hash": soak.manifest.hash,
        "toolchain_hash": soak.toolchain.tree_hash,
        "bend_version": soak.toolchain.version,
        "seed": soak.seed,
        "mode": soak.mode,
        "policy": soak.policy,
        "max_turns": soak.max_turns,
        "tasks": len(soak.manifest),
        "episodes_requested": soak.episodes,
        "throughput": throughput(metrics, elapsed_s, soak.jobs, cpu_s),
        "cache": soak.cache.to_json() if soak.cache is not None else {"enabled": False},
        "cache_distribution": soak.cache.distribution() if soak.cache else {},
        **blob,
    }


def summarise(report: dict) -> str:
    """The run in the terms M3 is stated in."""
    lines = [
        f"run        {report['run_id']}",
        f"bank       {report['tasks']} tasks, {report['bank_hash'][:12]}"
        f", bend {report['bend_version']}",
        f"policy     {report['policy']}, {report['mode']}, "
        f"max_turns {report['max_turns']}, seed {report['seed']}",
        "",
        f"episodes   {report['episodes']} of {report['episodes_requested']}"
        f"  ({report['turns']} turns)",
        f"solved     {report['solved']} ({report['solve_rate']:.1%})"
        f"  mean reward {report['mean_reward']:.3f}"
        f"  mean turns {report['mean_turns']:.2f}",
        f"best tier  " + "  ".join(f"{t}:{n}" for t, n in report["by_tier"].items()),
        f"turn tiers " + "  ".join(f"{t}:{n}" for t, n in report["turn_tiers"].items()),
        "",
        f"perf       {report['throughput']['verdicts_per_min']:.0f} verdicts/min"
        f"  ({report['throughput']['verdicts_per_min_per_core']:.0f}/core)"
        f"  over {report['throughput']['elapsed_s']:.0f}s"
        f" on {report['throughput']['jobs']} jobs",
    ]
    cpu = report["throughput"].get("checker_cpu_s")
    if cpu is not None:
        lines.append(
            f"cpu        {report['throughput']['ms_per_verdict_cpu']:.0f}"
            f"ms/verdict checker CPU"
            f"  ({report['throughput']['verdicts_per_cpu_min']:.0f} verdicts per"
            f" CPU-min)  amplification"
            f" {report['throughput']['cpu_amplification']:.2f}x")
    latency = report.get("latency_ms") or {}
    if latency:
        lines.append("latency    " + "  ".join(f"{k} {v:.0f}ms"
                                               for k, v in latency.items())
                     + f"  (over {report['fresh_checks']} fresh checks)")
    cache = report["cache"]
    if cache.get("enabled"):
        lines.append(f"cache      {cache['hits']} hits / {cache['lookups']} lookups"
                     f" ({cache['hit_rate']:.1%}), {cache['rows']} rows")
    families = "  ".join(f"{k}:{v}" for k, v in report["families"].items())
    lines.append("")
    lines.append(f"families   {families}")
    by_family = "  ".join(f"{k}:{v}" for k, v in
                          report["incidents_by_family"].items()) or "none"
    lines.append(f"incidents  {report['incidents']} ({by_family})"
                 f"   unexpected {report['incidents_unexpected']}"
                 f"   gate rejections {report['gate_rejections']}")
    if report["replay_disagreements"]:
        lines.append(f"REPLAY     the log does not agree with the run:")
        lines.extend(f"           {line}" for line in report["replay_disagreements"])
    return "\n".join(lines)


# --- entry point ---------------------------------------------------------------

def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("-n", "--episodes", type=int, default=10_000)
    parser.add_argument("-j", "--jobs", type=int, default=1,
                        help="worker threads; each drives its own env")
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--max-turns", type=int, default=DEFAULT_MAX_TURNS)
    parser.add_argument("--mode", choices=("dense", "sparse"), default="dense")
    parser.add_argument("--policy", choices=("noisy", "scripted"), default="noisy",
                        help="noisy re-runs the checker; scripted measures the cache")
    parser.add_argument("--tiers", type=int, nargs="*", default=None,
                        help="sample only from these tiers")
    parser.add_argument("--backend", default=None,
                        help="override the isolation backend; default is auto")
    parser.add_argument("--out", default=None,
                        help="directory for the log, cache, and report")
    parser.add_argument("--cache", default=None, help="default: <out>/cache.sqlite")
    parser.add_argument("--no-cache", action="store_true")
    parser.add_argument("--trajectory", default=None,
                        help="default: <out>/trajectory.jsonl")
    parser.add_argument("--progress-every", type=int, default=1000,
                        help="0 silences the progress line")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    if not len(manifest):
        print("soak: the manifest has no tasks", file=sys.stderr)
        return 2
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)

    out = Path(args.out) if args.out else None
    if out is not None:
        out.mkdir(parents=True, exist_ok=True)

    cache = None
    if not args.no_cache:
        cache = VerdictCache(args.cache or (out / "cache.sqlite" if out
                                            else "gavel-cache.sqlite"))
    trajectory = Trajectory(args.trajectory or (out / "trajectory.jsonl" if out
                                                else "trajectory.jsonl"))

    soak = Soak(
        manifest=manifest, toolchain=toolchain,
        sampler=tier_sampler(tuple(args.tiers)) if args.tiers else uniform_sampler,
        episodes=args.episodes, seed=args.seed, max_turns=args.max_turns,
        mode=args.mode, policy=args.policy, jobs=args.jobs,
        backend=args.backend, cache=cache, trajectory=trajectory)

    started = time.monotonic()
    started_cpu = child_cpu_s()

    def progress(count: int) -> None:
        if not args.progress_every or count % args.progress_every:
            return
        elapsed = time.monotonic() - started
        rate = count / elapsed if elapsed else 0.0
        left = (args.episodes - count) / rate if rate else 0.0
        print(f"  {count:6d}/{args.episodes}  {rate:7.1f} ep/s  "
              f"eta {left / 60:5.1f}m  incidents {soak.metrics.incidents}",
              file=sys.stderr, flush=True)

    failure: BaseException | None = None
    try:
        metrics = soak.run(on_episode=progress)
    except BaseException as exc:       # noqa: BLE001 - reported, then re-raised
        failure = exc
        metrics = soak.metrics

    elapsed = time.monotonic() - started
    logged = audit(trajectory, metrics, soak.families)
    report = build_report(soak, metrics, elapsed, trajectory.run_id, logged,
                          cpu_s=child_cpu_s() - started_cpu)
    print(summarise(report))

    if out is not None:
        (out / "report.json").write_text(
            json.dumps(report, indent=2) + "\n", encoding="utf-8")
        metrics.write(out / "metrics.json")
        print(f"\nwrote {out}/report.json, {out}/metrics.json, "
              f"{out}/trajectory.jsonl ({trajectory.episodes_written} episodes)")

    trajectory.close()
    # The cache is left open on purpose: a soak exists to warm it. The process
    # exiting closes it, and a caller embedding this keeps the connection.

    if failure is not None:
        print(f"\nsoak: stopped after {metrics.episodes} episodes: {failure}",
              file=sys.stderr)
        return 1
    if logged["disagreements"]:
        print("\nsoak: the log and the live report disagree -- one of them is "
              "not recording every episode", file=sys.stderr)
        return 1
    if logged["incidents_unexpected"]:
        print(f"\nsoak: {logged['incidents_unexpected']} submission(s) outside "
              f"the mutant family reproduced a mutant's solution",
              file=sys.stderr)
        return 1
    if metrics.episodes != args.episodes:
        print(f"\nsoak: {metrics.episodes} of {args.episodes} episodes completed",
              file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
