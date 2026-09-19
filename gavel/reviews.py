"""Where a review record lives: a directory no tool here writes.

SPEC's authoring loop ends at ``review`` for tier >= 3, and the record it leaves
behind is the bank's only evidence that a person read the laws. The record used
to be a ``"reviewed"`` key inside the task's ``meta.json``, written by
``tools/author.py --reviewer`` -- which is the defect rather than the feature:
``meta.json`` is a *derived* file, the pipeline rewrites it on every publish,
and a flag that writes the field made the pipeline able to manufacture the
evidence for its own claim. Eleven tier-3 tasks in the bank carried a record an
authoring agent wrote for itself, and nothing distinguished those bytes from a
person's.

A record now sits at ``reviews/<task_id>.json``, outside both the task
directory and the reference directory, and **nothing in this repository writes
there**. That is the property worth having, and it is checkable by reading the
source rather than by trusting a convention: ``tools/author.py`` refuses to
publish a tier >= 3 task without a record and cannot create one; a person
writes the file, and the commit that adds it carries the provenance the file
itself cannot.

The record is the same shape the key had, so the check that a record covers the
shipped laws did not have to change::

    {"by": "a name", "hashes": {"laws": "<sha256>", "prelude": "<sha256>"},
     "date": "2026-09-19"}

``hashes`` must equal the pair ``tools/publish.py`` derives from ``LAWS.bend``
and ``prelude.bend``. Editing either one after the fact leaves the record
pointing at laws the task no longer ships, which is what ``review_state`` calls
``stale`` -- checked, and reported, and not repaired by any tool here.
"""

from __future__ import annotations

import json
from pathlib import Path

REVIEWS_DIR = "reviews"
"""Relative to the repository root, beside ``manifest.json``."""


def review_path(repo: Path, task_id: str) -> Path:
    return Path(repo) / REVIEWS_DIR / f"{task_id}.json"


def load_review(repo: Path, task_id: str) -> dict | None:
    """The record for ``task_id``, or ``None`` if there is not a usable one.

    A file that is not JSON, or JSON that is not an object, is ``None`` rather
    than an exception: a malformed record is a record that does not attest to
    anything, which is exactly the state an absent one describes, and turning it
    into a traceback would fail a validation run for a reason no task in it is
    responsible for.
    """
    path = review_path(repo, task_id)
    if not path.is_file():
        return None
    try:
        record = json.loads(path.read_text())
    except (json.JSONDecodeError, UnicodeDecodeError, OSError):
        return None
    return record if isinstance(record, dict) else None
