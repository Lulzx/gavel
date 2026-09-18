"""The authoring pipeline: which stage refuses, and what the checkpoint binds to.

Two of these are about the review checkpoint rather than about the checker,
because that is the part with a rule in it: a review is recorded against the
hashes of the immutable files, so it has to go stale when they change. A
checkpoint that survives an edit to the laws is a signature on an empty page,
and nothing about a green pipeline would say so.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

from tools.author import (REVIEWED_KEY, Run, author, required_files,
                          review_is_stale, stage_review)

SOURCE_TASK = "t1-add-plus"


# --- files ------------------------------------------------------------------------

def test_a_new_task_is_told_what_it_is_missing(tmp_path):
    """The stage exists so that "not written yet" does not arrive as a checker
    result three stages later."""
    root = tmp_path / "tasks" / "1" / "t1-fresh"
    root.mkdir(parents=True)
    missing = required_files(root, tmp_path)
    assert "prompt.md" in missing
    assert "LAWS.bend" in missing
    assert "references/t1-fresh/solution.bend" in missing


def test_an_empty_file_counts_as_missing(tmp_path):
    """A stub that exists and is blank passes an is_file() check and then
    produces a task whose policy is given nothing to fill in."""
    root = tmp_path / "tasks" / "1" / "t1-fresh"
    root.mkdir(parents=True)
    for name in ("prompt.md", "LAWS.bend", "prelude.bend", "solution.bend"):
        (root / name).write_text("x\n")
    (root / "solution.bend").write_text("\n")
    assert "solution.bend (empty)" in required_files(root, tmp_path)


def test_required_files_wants_the_reference(tmp_path):
    """V1 and the episode are both about the reference, so a task without one
    should read as unfinished rather than as a check that failed."""
    root = tmp_path / "tasks" / "1" / "t1-fresh"
    root.mkdir(parents=True)
    for name in ("prompt.md", "LAWS.bend", "prelude.bend", "solution.bend"):
        (root / name).write_text("x\n")
    missing = required_files(root, tmp_path)
    assert "references/t1-fresh/PROOF.bend" in missing
    assert missing.count("references/t1-fresh/solution.bend") == 1


# --- the review checkpoint --------------------------------------------------------

def _meta(tier: int, hashes: dict, review: dict | None = None) -> dict:
    meta = {"task_id": "t-x", "tier": tier, "laws": ["a"], "hashes": hashes}
    if review is not None:
        meta[REVIEWED_KEY] = review
    return meta


def test_a_review_is_stale_when_the_laws_change():
    hashes = {"laws": "aaa", "prelude": "bbb"}
    reviewed = {"by": "lulzx", "hashes": hashes}
    assert not review_is_stale(_meta(3, hashes, reviewed))
    # Same task, one law edited.
    assert review_is_stale(_meta(3, {"laws": "zzz", "prelude": "bbb"}, reviewed))


def test_a_review_with_no_name_is_not_a_review():
    hashes = {"laws": "aaa", "prelude": "bbb"}
    assert review_is_stale(_meta(3, hashes, {"hashes": hashes}))


def _write_meta(root: Path, meta: dict) -> None:
    root.mkdir(parents=True, exist_ok=True)
    (root / "meta.json").write_text(json.dumps(meta, indent=2) + "\n")


def test_tier_three_holds_the_run_until_someone_signs(tmp_path):
    root = tmp_path / "t1-x"
    _write_meta(root, _meta(3, {"laws": "aaa", "prelude": "bbb"}))
    run = Run(task_id="t-x", root=root)
    stage_review(root, run, reviewer=None)
    assert run.blocked
    assert not run.ok
    assert run.stages[-1].name == "review"
    # And it says how to clear it, because the person reading it is the one who
    # has to read the laws first.
    assert "--reviewer" in run.stages[-1].detail


def test_below_tier_three_the_author_is_the_reviewer(tmp_path):
    root = tmp_path / "t1-x"
    _write_meta(root, _meta(2, {"laws": "aaa", "prelude": "bbb"}))
    run = Run(task_id="t-x", root=root)
    stage_review(root, run, reviewer=None)
    assert not run.blocked and run.ok


def test_approving_records_the_revision_and_clears_the_next_run(tmp_path):
    """The checkpoint is a gate on the revision, not a toll booth: a second run
    over unchanged laws must not ask again."""
    root = tmp_path / "t1-x"
    hashes = {"laws": "aaa", "prelude": "bbb"}
    _write_meta(root, _meta(3, hashes))

    first = Run(task_id="t-x", root=root)
    stage_review(root, first, reviewer="lulzx")
    assert not first.blocked and first.ok
    recorded = json.loads((root / "meta.json").read_text())[REVIEWED_KEY]
    assert recorded == {"by": "lulzx", "hashes": hashes}

    second = Run(task_id="t-x", root=root)
    stage_review(root, second, reviewer=None)
    assert not second.blocked and second.ok
    assert "lulzx" in second.stages[-1].detail


def test_editing_a_law_after_approval_reopens_the_checkpoint(tmp_path):
    root = tmp_path / "t1-x"
    _write_meta(root, _meta(3, {"laws": "aaa", "prelude": "bbb"},
                            {"by": "lulzx",
                             "hashes": {"laws": "aaa", "prelude": "bbb"}}))
    run = Run(task_id="t-x", root=root)
    stage_review(root, run, reviewer=None)
    assert not run.blocked          # approved at these laws
    # Now the laws change, exactly as tools/publish.py would re-derive them.
    _write_meta(root, _meta(3, {"laws": "changed", "prelude": "bbb"},
                            {"by": "lulzx",
                             "hashes": {"laws": "aaa", "prelude": "bbb"}}))
    again = Run(task_id="t-x", root=root)
    stage_review(root, again, reviewer=None)
    assert again.blocked


# --- the loop, against a real task --------------------------------------------------

@pytest.fixture
def scratch_repo(tmp_path):
    """A repository shaped like this one, holding one real task.

    Copied rather than run in place: the pipeline writes meta.json and a
    manifest, and a test that rewrites the bank it is testing is a test whose
    second run proves nothing.
    """
    for relative in (f"tasks/1/{SOURCE_TASK}", f"references/{SOURCE_TASK}"):
        shutil.copytree(Path(__file__).resolve().parent.parent / relative,
                        tmp_path / relative)
    return tmp_path


@pytest.mark.checker
def test_a_real_task_runs_the_whole_pipeline(scratch_repo, toolchain):
    """One task end to end, which is the only thing that says the stages are
    wired to each other rather than merely present."""
    root = scratch_repo / "tasks" / "1" / SOURCE_TASK
    manifest = scratch_repo / "manifest.json"
    run = author(root, repo=scratch_repo, manifest=manifest, backend="plain")

    assert [s.name for s in run.stages] == [
        "files", "derive", "mutants", "invariants", "episode", "review", "publish"]
    assert run.ok, [(s.name, s.detail) for s in run.stages]
    mutants = next(s for s in run.stages if s.name == "mutants")
    assert mutants.evidence["written"] == 0          # the fixture ships a corpus
    assert any(m["strong"] for m in mutants.evidence["mutants"])
    episode = next(s for s in run.stages if s.name == "episode")
    assert episode.evidence["reward"] == 1.0
    assert episode.evidence["tier"] == 4
    bank = json.loads(manifest.read_text())
    assert [t["task_id"] for t in bank["tasks"]] == [SOURCE_TASK]


@pytest.mark.checker
def test_the_mutants_stage_generates_a_corpus_where_there_is_none(scratch_repo,
                                                                  toolchain):
    """The gap this stage was added to close.

    Without it the pipeline went reference -> V1-V5, so every new task stopped
    at ``invariants`` on "V2: no mutants authored -- laws unguarded" -- a
    verdict that reads as being about the task when it is a step nobody ran.
    """
    reference = scratch_repo / "references" / SOURCE_TASK
    shutil.rmtree(reference / "mutants")
    root = scratch_repo / "tasks" / "1" / SOURCE_TASK
    run = author(root, repo=scratch_repo,
                 manifest=scratch_repo / "manifest.json", backend="plain")

    mutants = next(s for s in run.stages if s.name == "mutants")
    assert mutants.ok, mutants.detail
    assert mutants.evidence["written"] > 0
    assert (reference / "mutants").is_dir()
    assert run.ok, [(s.name, s.detail) for s in run.stages]


@pytest.mark.checker
def test_the_mutants_stage_leaves_an_authored_corpus_alone(scratch_repo, toolchain):
    """A corpus is the one part of a task that can be improved by hand.

    Re-running the pipeline must not silently replace it: that would mean a
    task's guards changed because someone ran the authoring loop again, which
    is the same class of quiet substitution the stage exists to prevent.
    """
    reference = scratch_repo / "references" / SOURCE_TASK
    mine = reference / "mutants" / "hand-written.bend"
    mine.write_text("import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  2n\n")

    root = scratch_repo / "tasks" / "1" / SOURCE_TASK
    run = author(root, repo=scratch_repo,
                 manifest=scratch_repo / "manifest.json", backend="plain")

    mutants = next(s for s in run.stages if s.name == "mutants")
    assert mutants.evidence["written"] == 0
    assert mine.is_file(), "the authored mutant was replaced"
    assert any(m["name"] == "hand-written" for m in mutants.evidence["mutants"])


@pytest.mark.checker
def test_a_task_without_a_reference_stops_at_the_first_stage(scratch_repo):
    """It should not reach the checker, and it should say what is missing."""
    shutil.rmtree(scratch_repo / "references" / SOURCE_TASK)
    root = scratch_repo / "tasks" / "1" / SOURCE_TASK
    run = author(root, repo=scratch_repo,
                 manifest=scratch_repo / "manifest.json", backend="plain")
    assert [s.name for s in run.stages] == ["files"]
    assert not run.ok
    assert "PROOF.bend" in run.stages[0].detail
    assert not (scratch_repo / "manifest.json").exists()


@pytest.mark.checker
def test_a_reference_that_proves_nothing_is_refused_before_anything_is_written(
        scratch_repo):
    """The stage the pipeline exists for. A solution that type-checks earns
    tier 2, and a bank of tier-2 references is a bank of tasks whose reward is
    0.1 for every well-formed submission. It has to stop here, not at publish.
    """
    task_root = scratch_repo / "tasks" / "1" / SOURCE_TASK
    reference = scratch_repo / "references" / SOURCE_TASK
    # The imports and nothing else: the law is declared and never proven.
    (reference / "PROOF.bend").write_text(
        "import Base\n"
        "import ./prelude.bend as P\n"
        "import ./solution.bend as S\n"
        "import ./LAWS.bend as L\n")

    run = author(task_root, repo=scratch_repo,
                 manifest=scratch_repo / "manifest.json", backend="plain")
    assert not run.ok
    assert [s.name for s in run.stages] == ["files", "derive", "mutants",
                                            "invariants"]
    assert "not 4" in run.stages[-1].detail
    assert not (scratch_repo / "manifest.json").exists()
    # And the episode stage never ran, so the task was never *rewarded*.
    assert "episode" not in [s.name for s in run.stages]
