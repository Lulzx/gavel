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

from gavel.reviews import review_path
from tools.author import Run, author, required_files, stage_review, stage_screens

SOURCE_TASK = "t1-add-plus"


# --- the screens stage -------------------------------------------------------------

HEAD = """import Base
import ./prelude.bend as P
import ./solution.bend as S

"""

STUB_ONE = """import Base
import ./prelude.bend as P

# TODO(policy): the target the laws below are about.
def other(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
"""

STUB_TWO = """import Base
import ./prelude.bend as P

# TODO(policy): named by no law in the fixtures below that use STUB_TWO.
def thing(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO

# TODO(policy): the target the laws below are about.
def other(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
"""


def _screens(tmp_path, laws: str, stub: str):
    """One run of the screens stage over a task directory holding just the two
    files it reads."""
    root = tmp_path / "tasks" / "1" / "t1-x"
    root.mkdir(parents=True, exist_ok=True)
    (root / "LAWS.bend").write_text(laws)
    (root / "solution.bend").write_text(stub)
    run = Run(task_id=root.name, root=root)
    stage_screens(root, run, tmp_path)
    return run.stages[-1]


def test_a_target_no_law_names_refuses_the_run(tmp_path):
    """Fact 33's shape, which was measured paying full reward: a target the law
    set never mentions is substitutable for the reference, so the law set is not
    about it in any sense. This is the one class a green V1-V5 run says nothing
    about, because no law fails for the body that ignores the target."""
    laws = HEAD + """law other_nil:
  {S.other(Nil{}) == Nil{} : List<&2, Nat>}
"""
    stage = _screens(tmp_path, laws, STUB_TWO)
    assert not stage.ok
    assert stage.evidence["refusals"] == ["[C] thing: named by no law at all"]


def test_a_target_named_only_in_a_premise_refuses_the_run(tmp_path):
    """The `all_le_put` shape in t4-inorder-transport, before its repair: the
    submission decides whether the premise is inhabitable, so a body that
    falsifies it proves the law vacuously and the target is free."""
    laws = HEAD + """law other_sorted:
  for +t: List<&2, Nat>
  for e: {S.thing(t) == True{} : Bool}
  {S.other(t) == True{} : Bool}
"""
    stage = _screens(tmp_path, laws, STUB_TWO)
    assert not stage.ok
    assert stage.evidence["refusals"] == [
        "[A] thing: named only in a premise, by ['other_sorted']"]


def test_a_relative_law_is_recorded_and_not_refused(tmp_path):
    """Flag B is the one anchors flag that is not a refusal. A target named on
    both sides of every law naming it is free up to a cancelling wrapper, and
    whether one exists depends on the type -- `len(xs) = ref(xs) + k` is pinned
    by `len_append` at k = 0 while a list-valued wrapper has no such
    constraint. The stage records it and leaves the judgement to the author."""
    laws = HEAD + """law other_append:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {S.other(xs <> ys) == P.append(S.other(xs), S.other(ys)) : List<&2, Nat>}
"""
    stage = _screens(tmp_path, laws, STUB_ONE)
    assert stage.ok
    assert stage.evidence["refusals"] == []
    assert "[B] other" in stage.detail


def test_a_law_of_its_own_with_an_absolute_anchor_is_clean(tmp_path):
    """The shape the two refusals are asking for: one law whose right-hand side
    calls no target, one that applies it with every argument open."""
    laws = HEAD + """law other_nil:
  {S.other(Nil{}) == Nil{} : List<&2, Nat>}

law other_cons:
  for +h: Nat
  for +t: List<&2, Nat>
  {S.other(h <> t) == h <> S.other(t) : List<&2, Nat>}
"""
    stage = _screens(tmp_path, laws, STUB_ONE)
    assert stage.ok
    assert stage.evidence == {"refusals": [], "readings": []}
    assert stage.detail.startswith("clean:")


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

def _write_meta(root: Path, meta: dict) -> None:
    root.mkdir(parents=True, exist_ok=True)
    (root / "meta.json").write_text(json.dumps(meta, indent=2) + "\n")


def _meta(tier: int, hashes: dict) -> dict:
    return {"task_id": "t-x", "tier": tier, "laws": ["a"], "hashes": hashes}


def _write_review(repo: Path, task_id: str, record: dict) -> None:
    path = review_path(repo, task_id)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(record, indent=2) + "\n")


def _checkpoint(tmp_path, tier: int, hashes: dict, record: dict | None = None):
    """A task directory at ``tmp_path/tasks/<tier>/t1-x`` and one run of the
    review stage over it, with a record in ``tmp_path/reviews`` if given."""
    root = tmp_path / "tasks" / str(tier) / "t1-x"
    _write_meta(root, _meta(tier, hashes))
    if record is not None:
        _write_review(tmp_path, root.name, record)
    run = Run(task_id=root.name, root=root)
    stage_review(root, run, tmp_path)
    return run


def test_tier_three_holds_the_run_until_someone_signs(tmp_path):
    run = _checkpoint(tmp_path, 3, {"laws": "aaa", "prelude": "bbb"})
    assert run.blocked
    assert not run.ok
    assert run.stages[-1].name == "review"
    # And it says how to clear it, because the person reading it is the one who
    # has to read the laws first.
    assert f"reviews/{run.task_id}.json" in run.stages[-1].detail
    assert "unreviewed" in run.stages[-1].detail


def test_below_tier_three_the_author_is_the_reviewer(tmp_path):
    run = _checkpoint(tmp_path, 2, {"laws": "aaa", "prelude": "bbb"})
    assert not run.blocked and run.ok


def test_no_flag_can_clear_the_checkpoint():
    """The defect Fact 27 is about, asserted as an absence.

    ``--reviewer NAME`` wrote the record into ``meta.json``, which made the
    pipeline that published a task the same pipeline that attested a person had
    read it. Eleven tier-3 tasks in the bank were in that state, every record
    written by the agent that had just written the task. The fix is that the
    capability is gone rather than discouraged, so this asserts the argument is
    not merely deprecated -- it is not there to pass.
    """
    import inspect
    from tools import author as author_module

    # The plumbing is gone, not hidden behind a deprecation: no parameter to
    # pass a name through, no constant naming the field it used to write.
    assert "reviewer" not in inspect.signature(author_module.author).parameters
    assert not hasattr(author_module, "REVIEWED_KEY")
    # And the command line refuses the argument rather than ignoring it.
    with pytest.raises(SystemExit):
        author_module.main([str(Path("tasks/3/t3-x")), "--reviewer", "lulzx"])


def test_a_record_outside_the_task_directory_clears_the_checkpoint(tmp_path):
    """The checkpoint is a gate on the revision, not a toll booth: a record that
    covers these laws must not ask again -- and it is read from ``reviews/``,
    the one place this pipeline does not write."""
    hashes = {"laws": "aaa", "prelude": "bbb"}
    first = _checkpoint(tmp_path, 3, hashes,
                        {"by": "lulzx", "hashes": hashes})
    assert not first.blocked and first.ok
    assert "lulzx" in first.stages[-1].detail

    second = _checkpoint(tmp_path, 3, hashes)
    assert not second.blocked and second.ok


def test_editing_a_law_after_approval_reopens_the_checkpoint(tmp_path):
    hashes = {"laws": "aaa", "prelude": "bbb"}
    run = _checkpoint(tmp_path, 3, hashes, {"by": "lulzx", "hashes": hashes})
    assert not run.blocked          # recorded at these laws
    # Now the laws change, exactly as tools/publish.py would re-derive them.
    again = _checkpoint(tmp_path, 3, {"laws": "changed", "prelude": "bbb"},
                        {"by": "lulzx", "hashes": hashes})
    assert again.blocked
    assert "stale" in again.stages[-1].detail


def test_a_record_missing_its_name_is_not_a_record(tmp_path):
    hashes = {"laws": "aaa", "prelude": "bbb"}
    run = _checkpoint(tmp_path, 3, hashes, {"hashes": hashes})
    assert run.blocked


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
        "files", "derive", "screens", "mutants", "invariants", "episode",
        "review", "publish"]
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
    assert [s.name for s in run.stages] == ["files", "derive", "screens",
                                            "mutants", "invariants"]
    assert "not 4" in run.stages[-1].detail
    assert not (scratch_repo / "manifest.json").exists()
    # And the episode stage never ran, so the task was never *rewarded*.
    assert "episode" not in [s.name for s in run.stages]
