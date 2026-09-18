"""Migrating the bank to another checker.

The interesting property is not that the tool runs; it is that it can tell a
clean bank from a broken one. A dry run that reports "0 quarantined" for every
candidate is indistinguishable from one that never looks, so the negative
control below is the test that carries the weight: a candidate with one line
changed must quarantine the whole bank and quote that line back.
"""

from __future__ import annotations

import json
import shutil
from dataclasses import replace
from pathlib import Path

import pytest

from gavel.tasks import load_manifest
from gavel.toolchain import SOURCE_DIR, ToolchainError, tree_hash
from tools.migrate import (Migration, candidate_toolchain, migrate_bank,
                           summarise)

SUCCESS_LINE_TS = '"All terms check.\\n"'
BROKEN_LINE_TS = '"Everything is fine.\\n"'


def write_bank(destination: Path, source: Path, task_id: str) -> Path:
    """A one-task bank whose paths are absolute, so it can live anywhere.

    ``load_manifest`` resolves a task's path against the manifest's own
    directory; an absolute path short-circuits that, which is what lets this
    test build a bank outside the repository instead of writing scratch files
    into the tree it is testing.
    """
    bank = json.loads(source.read_text())
    entry = next(e for e in bank["tasks"] if e["task_id"] == task_id)
    entry["path"] = str((source.parent / entry["path"]).resolve())
    entry["reference"] = str((source.parent / entry["reference"]).resolve())
    path = destination / "manifest.json"
    path.write_text(json.dumps({**bank, "tasks": [entry]}))
    return path


def broken_checker(repo: Path, tmp_path: Path) -> Path:
    """A copy of the pinned checker that no longer prints the success line."""
    home = tmp_path / "candidate"
    shutil.copytree(repo / "toolchain" / "2.0.5" / SOURCE_DIR, home / SOURCE_DIR)
    main_ts = home / SOURCE_DIR / "main.ts"
    source = main_ts.read_text()
    assert SUCCESS_LINE_TS in source
    main_ts.write_text(source.replace(SUCCESS_LINE_TS, BROKEN_LINE_TS))
    return home


# --- argument handling, no checker ---------------------------------------------

def test_from_points_at_a_directory_that_holds_the_checker(repo):
    vendored = repo / "toolchain" / "2.0.5"
    candidate = candidate_toolchain(_args(source=str(vendored), to=None))
    assert candidate.main_ts == vendored / SOURCE_DIR / "main.ts"
    # The tree hash is recomputed rather than trusted, so the report names the
    # bytes it actually tested.
    assert candidate.tree_hash == tree_hash(vendored / SOURCE_DIR)


def test_the_label_names_a_candidate_by_the_directory_it_came_from(repo, tmp_path):
    """The default is the name of the directory ``--from`` pointed at.

    That is right for ``toolchain/2.0.5/`` and useless for the launcher's
    ``~/.bend/app/2.0.4/rRKuW7/``, whose name is an opaque id -- so a launcher
    path is read with ``--label``, and the report says which version it was
    rather than which directory.
    """
    vendored = repo / "toolchain" / "2.0.5"
    assert candidate_toolchain(_args(source=str(vendored), to=None)).version == "2.0.5"
    opaque = tmp_path / "rRKuW7"
    shutil.copytree(vendored, opaque)
    assert candidate_toolchain(_args(source=str(opaque), to=None)).version == "rRKuW7"
    labelled = _args(source=str(opaque), to=None, label="2.0.4")
    assert candidate_toolchain(labelled).version == "2.0.4"


def test_a_directory_without_a_checker_is_refused(tmp_path):
    with pytest.raises(ToolchainError, match=SOURCE_DIR):
        candidate_toolchain(_args(source=str(tmp_path), to=None))


# --- the report ----------------------------------------------------------------

def test_the_summary_counts_by_tier_and_names_the_quarantined():
    rows = [Migration("a", 1, True), Migration("b", 1, False, problems=["V1"]),
            Migration("c", 2, True)]
    summary = summarise(rows, "2.0.6")
    assert (summary["clean"], summary["quarantined"], summary["tasks"]) == (2, 1, 3)
    assert summary["by_tier"] == {"1": {"clean": 1, "quarantined": 1},
                                  "2": {"clean": 1, "quarantined": 0}}


# --- the negative control, against the real checker ----------------------------

@pytest.mark.checker
def test_a_candidate_that_breaks_the_success_line_quarantines_the_bank(
        repo, toolchain, tmp_path):
    """One changed string, and the report must catch all of it.

    Changing nothing else is the point: the bank is fine, the checker is not,
    and the tool has to be able to say which. The evidence field is asserted on
    because a quarantine report that only says "tier 1" sends the reader back
    to a terminal to find out why.
    """
    candidate = replace(toolchain, root=broken_checker(repo, tmp_path),
                        version="broken")
    bank = write_bank(tmp_path, repo / "manifest.json", "t1-add-plus")

    rows = migrate_bank(bank, candidate, _config(), budget_ms=2000)

    assert [row.task_id for row in rows] == ["t1-add-plus"]
    assert rows[0].quarantined
    assert rows[0].reference_tier != 4
    assert BROKEN_LINE_TS.strip('"').removesuffix("\\n") in rows[0].evidence


@pytest.mark.checker
def test_a_candidate_identical_to_the_pin_quarantines_nothing(repo, toolchain,
                                                              tmp_path):
    """The control for the control: with the real checker, the bank is clean.

    Without this, the test above would still pass on a tool that quarantines
    everything unconditionally.
    """
    candidate = replace(toolchain, root=repo / "toolchain" / "2.0.5")
    bank = write_bank(tmp_path, repo / "manifest.json", "t1-add-plus")

    rows = migrate_bank(bank, candidate, _config(), budget_ms=2000)

    assert not rows[0].quarantined, rows[0].problems
    assert rows[0].reference_tier == 4


def _config():
    from gavel.check import CheckConfig
    return CheckConfig(backend="plain")


def _args(**over):
    class Args:
        source = None
        to = None
        label = None
    args = Args()
    for key, value in over.items():
        setattr(args, key, value)
    return args


def test_a_bank_that_loads_is_a_bank_that_can_be_migrated(repo, tmp_path):
    """The absolute-path trick the checker tests rely on, checked cheaply."""
    bank = write_bank(tmp_path, repo / "manifest.json", "t1-add-plus")
    manifest = load_manifest(bank)
    assert list(manifest) and manifest.get("t1-add-plus").laws_src
