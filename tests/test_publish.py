"""What the manifest may and may not claim about a task.

No checker: these are properties of the entry, not of the task's soundness.
"""

from __future__ import annotations

import shutil
from pathlib import Path

import pytest

from tools.publish import publish_task

REPO = Path(__file__).resolve().parents[1]
SOURCE_TASK = REPO / "tasks" / "1" / "t1-add-succ"


@pytest.fixture
def task_root(tmp_path):
    """A copy, because ``publish_task`` writes ``meta.json`` in place."""
    root = tmp_path / "tasks" / "1" / "t1-add-succ"
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
