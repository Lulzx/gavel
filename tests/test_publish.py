"""What the manifest may and may not claim about a task.

No checker: these are properties of the entry, not of the task's soundness.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

from tools.publish import main, publish_task

REPO = Path(__file__).resolve().parents[1]
SOURCE_TASK = REPO / "tasks" / "1" / "t1-add-plus"


@pytest.fixture
def task_root(tmp_path):
    """A copy, because ``publish_task`` writes ``meta.json`` in place."""
    root = tmp_path / "tasks" / "1" / "t1-add-plus"
    shutil.copytree(SOURCE_TASK, root)
    return root


def test_publishing_does_not_claim_a_task_is_valid(task_root):
    """It used to write ``"valid": true`` on every entry.

    Nothing had measured that. Validity is V1-V5's to state
    (``tools/validate.py``); a manifest entry that asserts it is a file
    describing what it hopes is true, which is the failure mode this whole
    project is built to avoid one layer down.
    """
    entry = publish_task(task_root, "2.0.5", repo=task_root.parents[2])
    assert "valid" not in entry
    assert entry["hash"]


def test_a_quarantine_survives_a_republish(task_root):
    """A bare ``tools.publish`` rebuilds every entry, and rebuilding from
    scratch is what erased hand-set quarantines -- the very command CI runs."""
    repo = task_root.parents[2]
    plain = publish_task(task_root, "2.0.5", repo=repo)
    held = publish_task(task_root, "2.0.5", repo=repo,
                        previous={**plain, "quarantined": True})
    assert held["quarantined"] is True
    assert "quarantined" not in plain


def test_a_quarantine_does_not_expire_when_the_task_is_edited(task_root):
    """The one case where the flag must survive a change: a quarantine that
    lifts as soon as someone touches the task is a delay, not an exclusion."""
    repo = task_root.parents[2]
    edited = publish_task(task_root, "2.0.5", repo=repo,
                          previous={"hash": "a hash from before the edit",
                                    "quarantined": True})
    assert edited["quarantined"] is True


def test_an_incomplete_task_stops_the_whole_run_before_it_writes(task_root,
                                                                 tmp_path, capsys):
    """Two agents share this tree, so a task caught mid-write is normal.

    Publishing is read-then-write per task, so this used to rewrite the metadata
    of every task before the incomplete one and then die on a raw
    FileNotFoundError -- leaving a run that half happened, which is not a state
    anyone can reason about afterwards. The cost of surviving that is one
    existence check up front.
    """
    good = task_root
    before = (good / "meta.json").stat().st_mtime_ns
    broken = tmp_path / "tasks" / "2" / "t2-mid-write"
    broken.mkdir(parents=True)
    (broken / "prelude.bend").write_text("import Base\n")

    manifest = tmp_path / "manifest.json"
    assert main([str(good), str(broken), "--manifest", str(manifest)]) == 1

    assert "t2-mid-write" in capsys.readouterr().err
    assert not manifest.is_file()
    # The good task was not touched either. It is listed first, so a per-task
    # check would have rewritten its metadata before reaching the broken one.
    # Compared by mtime rather than by content: ``publish_task`` writes the same
    # keys in the same order, so a rewrite can be byte-identical and a content
    # check would pass whether or not the guard exists.
    assert (good / "meta.json").stat().st_mtime_ns == before


def _fake_repo(tmp_path, names):
    """A repo with copies of a real task under the given ids."""
    repo = tmp_path / "repo"
    for name in names:
        shutil.copytree(SOURCE_TASK, repo / "tasks" / "1" / name)
    return repo


def test_a_held_task_is_skipped_by_a_bare_run(tmp_path, monkeypatch, capsys):
    """``HOLD`` is how a task is on disk and not in the bank.

    CI's in-sync step is a *bare* ``tools.publish`` followed by a diff, so a
    task held at the review checkpoint used to make that step fail on every
    push: the bare glob registered it, the diff saw seven new lines, and the
    build went red for a task nobody had read yet.
    """
    repo = _fake_repo(tmp_path, ["t1-normal", "t1-held"])
    (repo / "tasks" / "1" / "t1-held" / "HOLD").write_text("held for review\n")
    monkeypatch.setattr("tools.publish.REPO_ROOT", repo)

    manifest = tmp_path / "manifest.json"
    # Pre-seeded as if it had been registered before the hold went on, so the
    # test covers a bare run *dropping* one and not only never adding it. A
    # hold that expires when the task is already in the bank is not a hold.
    manifest.write_text(json.dumps({"tasks": [
        {"task_id": "t1-held", "tier": 1, "path": "tasks/1/t1-held",
         "reference": "references/t1-held", "hash": "stale"}]}))

    assert main(["--manifest", str(manifest)]) == 0
    ids = [t["task_id"] for t in json.loads(manifest.read_text())["tasks"]]
    assert ids == ["t1-normal"]
    assert "held" in capsys.readouterr().out


def test_a_held_task_is_refused_when_it_is_named(task_root, tmp_path, capsys):
    """A hold an argument can lift is not a hold, so naming one is an error
    rather than an override: deleting the marker is the deliberate act."""
    (task_root / "HOLD").write_text("held for review\n")
    manifest = tmp_path / "manifest.json"
    before = (task_root / "meta.json").stat().st_mtime_ns

    assert main([str(task_root), "--manifest", str(manifest)]) == 1

    err = capsys.readouterr().err
    assert "is held" in err and "HOLD" in err
    assert not manifest.is_file()
    # The refusal happens before the metadata is rewritten: a refusal that still
    # mutated the task would leave it neither published nor untouched, which is
    # the half-happened state the incomplete-task guard above exists to avoid.
    assert (task_root / "meta.json").stat().st_mtime_ns == before
