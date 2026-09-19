"""The docket: what it says, and the one thing it must never do.

The docket exists so a person can read the tier-3+ laws in one sitting. It is
not a review and must not become one: the whole point of Fact 27 is that the
machine that needs the judgement must not be able to write the record of it.
So one of these tests is an absence.

The rest are about the triage reading, which is the docket's only content: a
law no mutant kills, and a screen flag, are the two things it is for. Both were
measured pointing at real defects in this bank, and both would be silent if the
joining were wrong -- a block that prints every law at every kill count with the
findings list always empty looks exactly like a clean bank.
"""

from __future__ import annotations

from pathlib import Path

import pytest

from gavel.tasks import Task
from tools.docket import _block, main

REPO = Path(__file__).resolve().parent.parent


def _task(laws=("law_a", "law_b"), targets=("f",), tier=3) -> Task:
    return Task(task_id="t3-x", tier=tier, root=REPO / "tasks/3/t3-x",
                references=REPO / "references/t3-x", prompt="", laws_src="",
                prelude_src="", stub_src="", meta={"laws": list(laws),
                                                   "policy_targets": list(targets)},
                hash="deadbeef")


class _Report:
    """The four fields `_block` reads off a TaskReport, which is all it needs."""

    def __init__(self, kills, strong=("m1",), tiers=(3,), problems=(), review="unreviewed"):
        self.mutant_kills = kills
        self.mutant_strong = list(strong)
        self.mutant_tiers = list(tiers)
        self.problems = list(problems)
        self.review = review


@pytest.fixture
def no_flags(monkeypatch):
    """The screens half reads the task directory, which the synthetic rows here
    do not have. Stubbed so these tests are about the joining and not about the
    real law files, which `tools.screens`'s own tests already cover."""
    from tools import docket

    monkeypatch.setattr(docket, "_flags", lambda row, repo: {})


def test_a_law_no_mutant_kills_is_a_finding(no_flags):
    """The reading the empty case produces. `tools/mutate.py` rewrites a step,
    so no generated rule produces a body that is right at the step and wrong at
    the base -- the law is then a check on the reference, not on the policy, and
    it is the one the reviewer has to look at rather than the other way round."""
    lines, findings = _block({"task_id": "t3-x", "path": "tasks/3/t3-x"},
                             _task(), _Report({"law_a": 3, "law_b": 0}))
    assert "zero-kill law law_b" in findings
    assert "zero-kill law law_a" not in findings
    assert any("law_a 3, law_b 0" in line for line in lines)


def test_a_clean_task_has_no_findings(no_flags):
    """So that a passing run is distinguishable from a broken join. Without
    this the test above passes on a docket that reports nothing ever."""
    lines, findings = _block({"task_id": "t3-x", "path": "tasks/3/t3-x"},
                             _task(), _Report({"law_a": 3, "law_b": 2}))
    assert findings == []
    assert any(line.startswith("  screens") for line in lines)


def test_a_screen_flag_is_a_finding(tmp_path, monkeypatch):
    """A and C are refusals in the pipeline and B is a reading, but all three
    belong on the reviewer's shortlist -- the docket is the place they are read
    for tasks that were authored before the gate existed."""
    from tools import docket

    monkeypatch.setattr(docket, "_flags",
                        lambda row, repo: {"anchors": ["[B] f: both sides"]})
    _, findings = _block({"task_id": "t3-x", "path": "tasks/3/t3-x"},
                         _task(), _Report({"law_a": 3, "law_b": 2}))
    assert findings == ["anchors: [B] f"]


def test_the_docket_does_not_write_a_review_record():
    """The one invariant. ``--static`` is the path with the fewest moving parts,
    and a record appearing under ``reviews/`` for a task while this ran would be
    the forgery Fact 27 removed arriving through a side door."""
    reviews = REPO / "reviews"
    before = sorted(str(p) for p in reviews.rglob("*")) if reviews.exists() else None

    assert main(["t3-last-snoc", "--static", "--manifest",
                 str(REPO / "manifest.json")]) == 0

    after = sorted(str(p) for p in reviews.rglob("*")) if reviews.exists() else None
    assert after == before


def test_an_unknown_task_is_refused_not_ignored():
    """A typo must not read as a clean docket over zero tasks."""
    assert main(["t9-not-a-task", "--static"]) == 2
