"""The per-turn check protocol: submission in, Verdict out.

The shape of this module is dictated by two measured properties of the checker.

*It reports only the first type error.* One run of ``PROOF.bend`` cannot say
which laws passed, so partial credit needs a fixed point of per-law runs.

*It is order-sensitive.* ``book_valid`` walks ``book.order`` and registers each
def only after checking it (bend.ts:3732), so a proof may cite only laws
defined earlier in the file. That is what makes circular "proofs" impossible
and what makes a single successful run trustworthy -- but it also means an
isolation run must preserve the submission's own declaration order.
"""

from __future__ import annotations

import time
from dataclasses import dataclass, field, replace
from pathlib import Path

from . import reward as reward_mod
from . import runner
from .cache import VerdictCache, verdict_key
from .gate import check as gate_check
from .gate import imports_laws, law_definitions
from .laws import alias_map, parse_imports, split_top_level
from .lexer import KIND_NAME, tokenize
from .runner import DEFAULT_LIMITS, Backend, Limits, run_check, select_backend
from .tasks import (LAWS_FILE, PROOF_FILE, SOLUTION_FILE, Task, cleanup,
                    prepare_workdir, submission_hash)
from .toolchain import Toolchain
from .verdict import TIER_PARTIAL, CheckResult, Verdict

ISOLATION_FILE = "PROOF_i.bend"


@dataclass(frozen=True)
class CheckConfig:
    limits: Limits = DEFAULT_LIMITS
    attribute_partial: bool = True
    """Run the per-law fixed point when the whole submission does not check."""

    keep_workdir: bool = False
    max_runs: int = 64
    """A runaway guard: a check that needs more runs than this is a bug."""

    workdir_parent: Path | None = None

    backend: str = field(default_factory=runner.default_backend)
    """``auto`` -- bubblewrap on Linux, a plain subprocess elsewhere.

    A config carries the *name* rather than a resolved backend so that a task
    that is never checked never pays for the lookup, and so that a config is
    still a plain value that can be compared and serialised. The default comes
    from ``GAVEL_BACKEND``, which is how a job that is not about isolation
    opts out of it.
    """


@dataclass
class _Runs:
    results: list[CheckResult] = field(default_factory=list)

    def add(self, result: CheckResult) -> CheckResult:
        self.results.append(result)
        return result


def check_submission(task: Task, toolchain: Toolchain, files: dict[str, str],
                     config: CheckConfig = CheckConfig(),
                     cache: VerdictCache | None = None) -> Verdict:
    """Check one submission against one task and return the reward.

    ``cache`` is opt-in and passed here rather than configured on
    ``CheckConfig``: a config is a frozen value that callers compare and
    serialise, and a live database handle is neither. A miss stores the verdict
    it just computed, so the cache fills from ordinary use.
    """
    began = time.monotonic()
    key = None
    if cache is not None:
        key = verdict_key(task, toolchain, files,
                          select_backend(config.backend), config.limits,
                          attribute_partial=config.attribute_partial,
                          max_runs=config.max_runs)
        hit = cache.get(key)
        if hit is not None:
            return replace(hit, cached=True)

    def keep(verdict: Verdict) -> Verdict:
        if cache is not None and key is not None:
            cache.put(key, verdict)
        return verdict

    gate = gate_check(task, files)
    if not gate.ok:
        return keep(_finish(task, toolchain, files, gate, (),
                            solution_checks=False, proven=(), began=began))

    workdir = prepare_workdir(task, files, parent=config.workdir_parent)
    backend = select_backend(config.backend)
    runs = _Runs()
    try:
        solution_checks, proven = _run_protocol(task, toolchain, files, workdir,
                                                runs, config, backend)
    finally:
        if not config.keep_workdir:
            cleanup(workdir)
    verdict = _finish(task, toolchain, files, gate, runs.results,
                      solution_checks=solution_checks, proven=proven, began=began)
    incident = _mutant_incident(task, files, verdict.tier)
    if incident is not None:
        verdict = replace(verdict, reward=0.0, incident=incident)
    return keep(verdict)


def _mutant_incident(task: Task, files: dict[str, str], tier: int) -> str | None:
    """SPEC.md 7.4.2: a mutant's own solution, accepted by the checker.

    Each task ships solutions with one deliberate semantic bug, and V2 refuses
    the task unless its laws reject all of them. Reaching a proving tier with a
    solution byte-identical to one of them means that guarantee did not hold in
    a live episode, so the reward is withheld and the verdict carries the case.
    The tier is left as computed: it is the evidence.

    The comparison is on the whole file, not on a digest of the submission,
    because a policy is free to submit a different proof for the same solution.
    """
    if tier < TIER_PARTIAL:
        return None
    source = files.get(SOLUTION_FILE)
    if source is None:
        return None
    for path in task.mutant_paths:
        try:
            mutant = path.read_text()
        except OSError:
            continue
        if mutant == source:
            return (f"{SOLUTION_FILE} is byte-identical to the mutant "
                    f"{path.name}, and the checker accepted a proof for it "
                    f"(tier {tier})")
    return None


def _run_protocol(task: Task, toolchain: Toolchain, files: dict[str, str],
                  workdir: Path, runs: _Runs, config: CheckConfig,
                  backend: Backend) -> tuple[bool, tuple[str, ...]]:
    """Returns ``(solution_checks, proven)``; the tier follows from those."""
    laws = list(task.laws)
    n_laws = len(laws)
    proof_src = files.get(PROOF_FILE, "")
    filled = law_definitions(proof_src, laws)
    filled_in_order = tuple(law for law in laws if law in filled)

    # Both shortcuts below read the full run as a statement about the laws,
    # which it only is if the file imported them. An empty PROOF.bend checks
    # (there is nothing in it to fail) and proves nothing; it was measured
    # reading tier 4 before this guard existed. The gate refuses such a file
    # first; this is the layer that holds if the gate is ever wrong.
    opens_laws = imports_laws(proof_src)

    full = runs.add(run_check(toolchain, workdir, PROOF_FILE, config.limits,
                              backend))
    if full.ok and opens_laws and len(filled) == n_laws:
        return (True, tuple(laws))

    # A run whose only complaint is that laws are still open proves two things
    # at once: nothing else is a hole (that would inflate the count), and every
    # def that is present checked. Declaration order makes that sound, so this
    # is the whole verdict in one run.
    if (opens_laws and full.todo_count is not None
            and full.todo_count == n_laws - len(filled_in_order)):
        return (True, filled_in_order)

    solution_checks = _solution_checks(task, toolchain, workdir, runs, config,
                                       backend)
    if not solution_checks:
        return (False, ())
    if not config.attribute_partial or not filled_in_order:
        return (True, ())

    proven = _fixed_point(task, toolchain, workdir, proof_src, laws, filled,
                          runs, config, backend)
    return (True, proven)


def _solution_checks(task: Task, toolchain: Toolchain, workdir: Path,
                     runs: _Runs, config: CheckConfig, backend: Backend) -> bool:
    """Whether ``solution.bend`` is a well-typed program on its own."""
    if len(runs.results) >= config.max_runs:
        return False
    return runs.add(run_check(toolchain, workdir, SOLUTION_FILE, config.limits,
                              backend)).ok


def _fixed_point(task: Task, toolchain: Toolchain, workdir: Path,
                 proof_src: str, laws: list[str], filled: dict[str, object],
                 runs: _Runs, config: CheckConfig,
                 backend: Backend) -> tuple[str, ...]:
    """Credit each law whose proof stands on its own, to a fixed point.

    A law is credited when an isolation run -- the header, the helpers it can
    reach, and the defs of the already-credited laws plus this one -- leaves
    exactly the uncredited laws open and nothing else. A def with an internal
    ``?TODO`` inflates the open count and is never credited; a proof that
    leans on a law not yet credited is a dead claim and fails outright.
    """
    imports = parse_imports(proof_src)
    header = "\n".join(imp.raw for imp in imports if imp.raw)

    index = {law: chunk.index for law, chunk in filled.items()}
    helpers = _usable_helpers(proof_src, imports, laws)

    proven: list[str] = []
    changed = True
    passes = 0
    while changed and passes < len(laws):
        passes += 1
        changed = False
        for law in laws:
            if law in proven or law not in filled:
                continue
            if len(runs.results) >= config.max_runs:
                return tuple(proven)
            selected = [*proven, law]
            body = _isolation_source(header, helpers, filled, selected, index)
            (workdir / ISOLATION_FILE).write_text(body)
            result = runs.add(run_check(toolchain, workdir, ISOLATION_FILE,
                                        config.limits, backend))
            remaining = len(laws) - len(selected)
            if result.ok or (result.todo_count is not None
                             and result.todo_count == remaining):
                proven.append(law)
                changed = True
    (workdir / ISOLATION_FILE).unlink(missing_ok=True)
    return tuple(proven)


def _isolation_source(header: str, helpers: list[tuple[int, str]],
                      filled: dict[str, object], selected: list[str],
                      index: dict[str, int]) -> str:
    parts = [(index[law], getattr(filled[law], "text")) for law in selected]
    parts.extend(helpers)
    parts.sort(key=lambda item: item[0])
    body = "\n\n".join(text for _, text in parts)
    return f"{header}\n\n{body}\n"


def _usable_helpers(proof_src: str, imports, laws: list[str]) -> list[tuple[int, str]]:
    """Helper defs that do not, by themselves, depend on an open law.

    A helper that cites a law would make every isolation run fail until that
    law is credited, which would withhold credit from laws that have nothing to
    do with it. Dropping it is conservative in the safe direction: it can only
    cost the submission credit, never grant it.
    """
    aliases = alias_map(imports)
    law_module = _module_of(imports)
    law_set = set(laws)
    out: list[tuple[int, str]] = []
    for chunk in split_top_level(proof_src):
        if chunk.kind != "def" or not chunk.name.startswith("Policy."):
            continue
        if _cited_laws(chunk.text, aliases, law_module, law_set):
            continue
        out.append((chunk.index, chunk.text))
    return out


def _cited_laws(text: str, aliases: dict[str, str], law_module: str,
                laws: set[str]) -> set[str]:
    """Laws this chunk names, resolved through the submission's own aliases."""
    found: set[str] = set()
    try:
        tokens = tokenize(text)
    except Exception:
        return found
    for token in tokens:
        if token.kind != KIND_NAME:
            continue
        head, dot, tail = token.text.partition(".")
        if not dot or tail not in laws:
            continue
        module = aliases.get(head, head)
        if module == law_module:
            found.add(tail)
    return found


def _module_of(imports) -> str | None:
    """The namespace this file's import of LAWS.bend binds, if it has one."""
    for imp in imports:
        if imp.path is not None and imp.path.endswith("/" + LAWS_FILE):
            return imp.module or "LAWS"
    return None


def _finish(task: Task, toolchain: Toolchain, files: dict[str, str], gate, checks,
            *, solution_checks: bool, proven: tuple[str, ...], began: float) -> Verdict:
    tier, reward = reward_mod.compute(
        gate_ok=gate.ok, solution_checks=solution_checks,
        proven=len(proven), n_laws=task.n_laws)
    failed = tuple(law for law in task.laws if law not in proven)
    return Verdict(
        task_id=task.task_id,
        tier=tier,
        reward=reward,
        n_laws=task.n_laws,
        proven=proven,
        failed=failed,
        gate=gate,
        checks=tuple(checks),
        toolchain_hash=toolchain.tree_hash,
        task_hash=task.hash,
        submission_hash=submission_hash(files),
        difficulty_weight=task.difficulty_weight,
        ms=int((time.monotonic() - began) * 1000),
    )
