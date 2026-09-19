"""Run one task through the authoring stages, and stop where a human is owed.

SPEC.md's pipeline is translate -> laws -> reference -> mutants -> calibrate ->
publish. Two of those are model work: nothing here translates a module or
invents a law. What it can do is refuse to carry a task past a stage it has not
passed, and that is the whole of this file. A task is a reward function, and the
failure mode worth engineering against is one that *looks* finished -- the laws
that an argument-ignoring body satisfies, the reference that proves them
(README, "What makes a law worth training on"). Those are measurements, so they
belong in a gate rather than in a maxim that authors are asked to remember.

The stages, in order:

    files       every file the later stages read is present and non-empty
    derive      metadata from the task's own files (tools/publish.py)
    screens     the static screens (tools/screens.py), before any checker run
    mutants     generate a corpus; refuse if any mutant still proves every law
    invariants  V1-V5 on the derived task (gavel/validate.py)
    episode     the reference scored through GavelEnv, not through the checker
    review      tier >= 3 stops here until a person has written the record
    publish     the manifest entry, written only once everything above passed

Why an episode and not just V1. V1 asks whether the checker accepts the
reference. The episode asks the strictly different question of whether the task
*rewards* it -- gate open, tier 4, reward 1.0, done on the first turn -- and it
asks through the same env the training loop drives, so the pipeline cannot be
satisfied by a task the loop would not be. A reference that V1 passes and the
episode fails is a task whose reward is not what its laws say.

The review binds to a revision, not to a task id. The record is taken against
the hashes of the immutable files, so editing LAWS.bend or prelude.bend after it
makes it stale and the checkpoint fires again. A checkpoint that survives an
edit to the thing it was reviewing is a signature on an empty page.

The review is also the one stage this file cannot satisfy, which is the point:
it reads ``reviews/<task_id>.json``, a path no tool here writes, so a record in
it exists because a person put it there.

Usage:
    uv run python -m tools.author tasks/2/t2-new-thing
    uv run python -m tools.author tasks/3/t3-new-thing
    uv run python -m tools.author tasks/1/t1-new-thing --json

Exit codes: 0 published, 1 a stage failed, 3 awaiting review. A tier 3 task
reaches 3 every time until a person writes ``reviews/<task_id>.json``; there is
deliberately no flag that clears it, and ``gavel/reviews.py`` says why.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.check import CheckConfig  # noqa: E402
from gavel.env import Action, GavelEnv  # noqa: E402
from gavel.reviews import load_review  # noqa: E402
from gavel.tasks import (HOLD_FILE, LAWS_FILE, PRELUDE_FILE, PROOF_FILE,  # noqa: E402
                         SOLUTION_FILE, Manifest, is_held, load_task)
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.validate import (DEFAULT_BUDGET_MS, REVIEW_TIER,  # noqa: E402
                            review_state, validate_task)
from tools.screens import anchor_reports, general_flags  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent
MANIFEST = REPO_ROOT / "manifest.json"

"""``REVIEW_TIER`` and the state it gates live in ``gavel.validate``, because
the check that a record is still about the shipped laws is run by validation as
well as by this checkpoint, and two copies of "is this review stale" is two
answers to the same question. Below the tier an author's own reading is the
review; at and above it the laws can pin more than a person can check by eye,
which is where a named reviewer is worth the interruption. Where the record
itself lives -- and why nothing here may write it -- is ``gavel/reviews.py``."""

FILES = (LAWS_FILE, PRELUDE_FILE, SOLUTION_FILE)


@dataclass
class Stage:
    name: str
    ok: bool
    detail: str
    evidence: dict[str, Any] = field(default_factory=dict)


@dataclass
class Run:
    task_id: str
    root: Path
    stages: list[Stage] = field(default_factory=list)
    entry: dict[str, Any] | None = None
    blocked: bool = False
    """True when the run stopped at the review checkpoint rather than failing."""

    @property
    def ok(self) -> bool:
        return not self.blocked and all(s.ok for s in self.stages)

    def to_json(self) -> dict[str, Any]:
        return {"task_id": self.task_id, "root": str(self.root),
                "ok": self.ok, "blocked": self.blocked,
                "stages": [{"name": s.name, "ok": s.ok, "detail": s.detail,
                            "evidence": s.evidence} for s in self.stages]}


def required_files(root: Path, repo: Path = REPO_ROOT) -> list[str]:
    """The files every later stage reads, relative to the task directory.

    ``meta.json`` is not among them: it is derived, so requiring it would make
    a new task fail a stage for not having the output of the stage after it.
    The reference is among them, because the two stages that matter most --
    V1 and the episode -- are both about the reference, and "no reference yet"
    should read as that rather than as a checker result.

    Kept separate from the run so that "this task is not finished yet" is a
    checkable property of a directory rather than something an author learns by
    watching a stage fail.
    """
    reference = repo / "references" / root.name
    missing = [name for name in ("prompt.md", *FILES)
               if not (root / name).is_file()]
    missing += [f"references/{root.name}/{name}"
                for name in (SOLUTION_FILE, PROOF_FILE)
                if not (reference / name).is_file()]
    for name in ("prompt.md", *FILES):
        if (root / name).is_file() and not (root / name).read_text().strip():
            missing.append(f"{name} (empty)")
    return missing


# --- stages -----------------------------------------------------------------------

def stage_files(root: Path, run: Run, repo: Path) -> None:
    missing = required_files(root, repo)
    run.stages.append(Stage(
        "files", not missing,
        "complete" if not missing else f"missing {', '.join(missing)}"))


def stage_derive(root: Path, run: Run, repo: Path, version: str) -> None:
    from tools.publish import publish_task

    try:
        run.entry = publish_task(root, version, repo)
    except (SystemExit, KeyError) as exc:
        run.stages.append(Stage("derive", False, f"{type(exc).__name__}: {exc}"))
        return
    meta = json.loads((root / "meta.json").read_text())
    run.stages.append(Stage(
        "derive", True,
        f"tier {run.entry['tier']}, {len(meta['laws'])} laws: "
        f"{', '.join(meta['laws'])}",
        {"laws": meta["laws"], "policy_targets": meta["policy_targets"]}))


ANCHOR_REFUSALS = ("A", "C")

"""The two `anchors` flags that are refusals rather than readings.

A is a target every occurrence of which sits inside a `for e: {...}` premise:
the submission decides whether the premise is inhabitable, so a body that
falsifies it proves the law vacuously and nothing constrains the target. C is a
target no law names at all. Both were measured paying full reward in this bank
before they were closed -- Fact 33 for C, the `all_le_put`/`all_ge_put` pair in
`t4-inorder-transport` for A -- and neither is escapable by anything the laws
can see.

B is deliberately *not* a refusal. A target named on both sides of every law
that names it is free up to a cancelling wrapper, and whether one exists depends
on the type: `len(xs) = ref(xs) + k` fails `len_append` at every `k` but zero,
while a list-valued wrapper has no such constraint. So B is recorded and left to
the author, which is the same triage rule the screen's own docstring states.
"""


def stage_screens(root: Path, run: Run, repo: Path) -> None:
    """The static screens as a stage, so that "run the screens" is the
    pipeline's step and not a sentence in a brief that an author may skip.

    None of these runs the checker, so this costs no verdict and cannot see a
    body that escapes. It sees the shapes where the law set itself leaves a
    target free, which is what every full-reward hole this bank has paid for on
    a static reading has been.
    """
    row = {"task_id": root.name, "path": root.relative_to(repo).as_posix()}
    refusals, readings = [], []
    for target, (flag, why) in sorted(anchor_reports(row, repo).items()):
        line = f"[{flag}] {target}: {why}"
        (refusals if flag in ANCHOR_REFUSALS else readings).append(line)
    for target, sigs in sorted(general_flags(row, repo).items()):
        readings.append(f"{target}: no law applies it with every argument open "
                        f"({len(sigs)} application(s), all with a literal)")
    if refusals:
        detail = "; ".join(f"anchors {r}" for r in refusals)
    elif readings:
        detail = ("no refusal; triage: " + "; ".join(readings))
    else:
        detail = "clean: every target has a law of its own with an absolute anchor"
    run.stages.append(Stage("screens", not refusals, detail,
                            {"refusals": refusals, "readings": readings}))


def stage_mutants(root: Path, run: Run, repo: Path, toolchain: Toolchain) -> None:
    """The stage that was missing, and the reason a fresh task always stopped.

    SPEC's pipeline is translate -> laws -> reference -> **mutants** -> calibrate
    -> publish, and this driver went straight from the reference to V1-V5. So
    every new task failed ``invariants`` on "V2: no mutants authored -- laws
    unguarded", which reads like a verdict about the task when it is a step
    nobody ran. The authoring loop then had to be driven by hand for the one
    part that was already mechanised in ``tools/mutate.py``.

    Generated only when the directory is empty. A mutant corpus is the one part
    of a task that can be improved by hand, and quietly replacing one would mean
    a task's guards changed because someone re-ran the pipeline -- the failure
    this stage exists to prevent, one level up. ``mutants/`` deleted, the corpus
    is regenerated on the next run.
    """
    from tools.mutate import (Mutant, check_mutants, dedupe, mutants_of,
                              write_mutants)

    entry = run.entry or {"task_id": root.name, "reference": f"references/{root.name}"}
    try:
        task = load_task(root, entry, repo)
    except Exception as exc:                          # noqa: BLE001 - reported, not raised
        run.stages.append(Stage("mutants", False, f"{type(exc).__name__}: {exc}"))
        return

    existing = sorted((task.references / "mutants").glob("*.bend"))
    if existing:
        # Labelled the same way a generated one is, so the tier table reads the
        # same whichever produced it. Nothing here knows whether a mutant is
        # hand-written, and ``check_mutants`` is what decides it anyway.
        mutants = [Mutant(name=p.stem, rule="authored", source=p.read_text(),
                          strong=True) for p in existing]
        wrote = 0
    else:
        mutants = dedupe(mutants_of(task.reference_solution), task.reference_solution)
        wrote = len(write_mutants(task, mutants))

    reports = check_mutants(task, toolchain, mutants)
    strong = [m for m in reports if m["strong"]]
    escaped = [m for m in reports if not m["caught"]]
    evidence = {
        "written": wrote,
        "mutants": [{"name": m["name"], "tier": m["tier"], "strong": m["strong"]}
                    for m in reports],
    }
    source = f"generated {wrote}" if wrote else f"kept {len(existing)} authored"
    if not reports:
        run.stages.append(Stage("mutants", False,
                                "no mutant could be derived from the reference",
                                evidence))
    elif escaped:
        run.stages.append(Stage(
            "mutants", False,
            f"({source}) {len(escaped)} still prove every law: "
            f"{', '.join(m['name'] for m in escaped)}", evidence))
    elif not strong:
        run.stages.append(Stage(
            "mutants", False,
            f"({source}) none of {len(reports)} type-checks, so no law was ever "
            f"exercised", evidence))
    else:
        run.stages.append(Stage(
            "mutants", True,
            f"({source}) {len(strong)} of {len(reports)} strong", evidence))


def stage_invariants(root: Path, run: Run, repo: Path, toolchain: Toolchain,
                     budget_ms: int, config: CheckConfig) -> None:
    entry = run.entry or {"task_id": root.name, "reference": f"references/{root.name}"}
    task = load_task(root, entry, repo)
    report = validate_task(task, toolchain, budget_ms=budget_ms, config=config)
    detail = "; ".join(report.problems) or (
        "; ".join(report.warnings) if report.warnings else "V1-V5 pass")
    run.stages.append(Stage(
        "invariants", report.valid, detail,
        {"reference_ms": report.reference_ms, "checked": report.checked,
         "warnings": report.warnings,
         "mutant_strong": [n for n, _ in report.mutant_strong]}))


def stage_episode(root: Path, run: Run, repo: Path, toolchain: Toolchain,
                  config: CheckConfig, backend: str | None) -> None:
    """The reference, scored the way a policy's submission would be."""
    entry = run.entry or {"task_id": root.name, "reference": f"references/{root.name}"}
    task = load_task(root, entry, repo)
    manifest = Manifest(path=MANIFEST, bank={"version": 1,
                                             "bend_version": toolchain.version},
                        tasks={task.task_id: task})
    env = GavelEnv(manifest=manifest, toolchain=toolchain, mode="sparse",
                   max_turns=1, config=config, backend=backend)
    try:
        env.reset(task.task_id)
        _, reward, done, verdict = env.step(Action(files={
            SOLUTION_FILE: task.reference_solution,
            PROOF_FILE: task.reference_proof}))
    finally:
        env.close()
    evidence = {"reward": reward, "done": done, "tier": verdict.tier,
                "proven": list(verdict.proven), "laws": list(task.laws)}
    if reward == 1.0 and done and verdict.tier == 4:
        run.stages.append(Stage("episode", True, "reference earns 1.0", evidence))
    else:
        run.stages.append(Stage(
            "episode", False,
            f"the reference earns {reward} at tier {verdict.tier} "
            f"({verdict.tier_name}), proved {list(verdict.proven)} of "
            f"{list(task.laws)}; the task does not pay what its laws say",
            evidence))


def stage_review(root: Path, run: Run, repo: Path | None = None) -> None:
    """The checkpoint, which this pipeline can test and cannot clear.

    It used to clear it: ``--reviewer NAME`` wrote a ``"reviewed"`` key into
    ``meta.json``, which is a *derived* file this pipeline rewrites on every
    publish. So the tool that published a task was also the tool that attested a
    person had read its laws, and eleven tier-3 tasks in the bank carried a
    record an authoring agent wrote for itself. The flag is gone and the record
    moved to ``reviews/<task_id>.json`` (``gavel/reviews.py``), a path nothing
    here writes; a person creates that file, and the commit that adds it is the
    provenance the record itself cannot carry.

    That is the whole of what this stage can be. It reads the record, refuses
    to publish without one, and has no way to make one -- which is the property
    worth having, because a checkpoint the guarded pipeline can satisfy on its
    own is a signature on an empty page.
    """
    meta = json.loads((root / "meta.json").read_text())
    tier = int(meta["tier"])
    if tier < REVIEW_TIER:
        run.stages.append(Stage("review", True, f"tier {tier}: author's own"))
        return
    record = load_review(repo or REPO_ROOT, root.name)
    if review_state(meta, tier, record) == "current":
        run.stages.append(Stage(
            "review", True, f"reviewed by {record['by']} at these laws"))
        return
    run.blocked = True
    state = review_state(meta, tier, record)
    run.stages.append(Stage(
        "review", False,
        f"tier {tier}: {state} -- write reviews/{root.name}.json with the "
        f"reviewer's name and the hashes in meta.json once the laws have been "
        f"read; this pipeline cannot write it and will not publish without it"))


def stage_publish(root: Path, run: Run, manifest: Path) -> None:
    assert run.entry is not None
    if is_held(root):
        run.stages.append(Stage(
            "publish", False,
            f"held: {HOLD_FILE} is present, so this task is on disk and not in "
            f"the bank; remove {root / HOLD_FILE} to register it"))
        return
    bank = (json.loads(manifest.read_text()) if manifest.is_file()
            else {"version": 1, "tasks": []})
    entries = {e["task_id"]: e for e in bank.get("tasks", [])}
    entries[run.entry["task_id"]] = run.entry
    bank["tasks"] = sorted(entries.values(), key=lambda e: (e["tier"], e["task_id"]))
    manifest.write_text(json.dumps(bank, indent=2) + "\n")
    run.stages.append(Stage("publish", True,
                            f"manifest now has {len(bank['tasks'])} tasks"))


# --- the loop ---------------------------------------------------------------------

def author(root: Path, *, repo: Path = REPO_ROOT,
           version: str = DEFAULT_VERSION,
           manifest: Path = MANIFEST,
           budget_ms: int = DEFAULT_BUDGET_MS,
           backend: str | None = None) -> Run:
    """Every stage, in order, stopping at the first refusal."""
    root = Path(root).resolve()
    repo = Path(repo).resolve()
    run = Run(task_id=root.name, root=root)
    config = CheckConfig() if backend is None else CheckConfig(backend=backend)

    stage_files(root, run, repo)
    if not run.ok:
        return run

    # The toolchain is loaded before anything that needs it so that a drifted
    # pin reads as a pin problem rather than as a mysterious stage failure.
    toolchain = Toolchain.load(version)

    stage_derive(root, run, repo, version)
    if not run.ok:
        return run

    # Before the mutants stage: a refusal here is a two-line law fix, while the
    # same defect found after a corpus has been generated costs a rewrite of the
    # laws plus every mutant that was written against them.
    stage_screens(root, run, repo)
    if not run.ok:
        return run

    # Before the invariants, because V2 is one of them and it reads this
    # directory. The order is the one SPEC gives, and it is also the only order
    # in which V2 asks a question rather than reporting a missing file.
    stage_mutants(root, run, repo, toolchain)
    if not run.ok:
        return run

    stage_invariants(root, run, repo, toolchain, budget_ms, config)
    if not run.ok:
        return run

    stage_episode(root, run, repo, toolchain, config, backend)
    if not run.ok:
        return run

    stage_review(root, run, repo)
    if not run.ok:
        return run

    stage_publish(root, run, manifest)
    return run


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("task", help="the task directory, e.g. tasks/2/t2-thing")
    parser.add_argument("--manifest", default=str(MANIFEST))
    parser.add_argument("--version", default=DEFAULT_VERSION)
    parser.add_argument("--budget-ms", type=int, default=DEFAULT_BUDGET_MS)
    parser.add_argument("--backend", default=None,
                        help="checker isolation backend; default is the one "
                             "GAVEL_BACKEND selects")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args(argv)

    run = author(Path(args.task), version=args.version,
                 manifest=Path(args.manifest),
                 budget_ms=args.budget_ms, backend=args.backend)

    if args.json:
        print(json.dumps(run.to_json(), indent=2))
    else:
        for stage in run.stages:
            mark = "ok  " if stage.ok else ("hold" if run.blocked else "FAIL")
            print(f"[{mark}] {stage.name:11s} {stage.detail}")
        if run.blocked:
            print(f"\n{run.task_id} is awaiting review; nothing was published.")
        elif run.ok:
            print(f"\n{run.task_id} passed every stage.")
    return 3 if run.blocked else (0 if run.ok else 1)


if __name__ == "__main__":
    raise SystemExit(main())
