"""The bank's own identity, and the pieces of a task the harness reads.

No checker: these are the properties a manifest has to have before anything is
run against it.
"""

from __future__ import annotations

from dataclasses import replace

from gavel.tasks import Manifest


def test_the_bank_hash_is_stable_across_loads(manifest):
    assert manifest.hash == manifest.hash


def test_the_bank_hash_changes_when_a_task_changes(manifest):
    """A task's own hash moves the bank's, whatever else stays the same."""
    task_id = next(iter(manifest.tasks))
    tasks = dict(manifest.tasks)
    tasks[task_id] = replace(tasks[task_id], hash="deadbeef")
    assert Manifest(path=manifest.path, bank=manifest.bank,
                    tasks=tasks).hash != manifest.hash


def test_the_bank_hash_changes_when_a_task_is_added(manifest):
    task_id = next(iter(manifest.tasks))
    tasks = {k: v for k, v in manifest.tasks.items() if k != task_id}
    assert Manifest(path=manifest.path, bank=manifest.bank,
                    tasks=tasks).hash != manifest.hash


def test_the_bank_hash_changes_with_the_checker(manifest):
    """Two banks of identical tasks are not the same bank if one of them is
    checked by a different bend."""
    bank = {**manifest.bank, "bend_version": "2.0.6"}
    assert Manifest(path=manifest.path, bank=bank,
                    tasks=manifest.tasks).hash != manifest.hash


def test_the_bank_hash_ignores_fields_that_are_not_the_bank(manifest):
    """Calibration numbers and timestamps move in manifest.json without
    changing what a task is, so a log keyed on them would be useless."""
    bank = {**manifest.bank, "created": "whenever",
            "tasks": manifest.bank.get("tasks", [])}
    assert Manifest(path=manifest.path, bank=bank,
                    tasks=manifest.tasks).hash == manifest.hash


def test_the_bank_hash_does_not_depend_on_dict_order(manifest):
    tasks = dict(reversed(list(manifest.tasks.items())))
    assert Manifest(path=manifest.path, bank=manifest.bank,
                    tasks=tasks).hash == manifest.hash


def test_every_task_carries_its_own_hash(manifest):
    assert all(task.hash for task in manifest)


def test_the_bank_knows_its_tiers(manifest):
    assert manifest.by_tier(1)
    assert all(t.tier == 1 for t in manifest.by_tier(1))
    tiers = {task.tier for task in manifest}
    assert sum(len(manifest.by_tier(t)) for t in tiers) == len(manifest)


def test_a_quarantined_task_is_loaded_out_of_the_bank(manifest, repo, tmp_path):
    """The exclusion has to be enforced where the bank is read.

    Written against a manifest on disk rather than against ``Manifest``
    directly, because the flag's whole job is to stop ``load_task`` from ever
    seeing the directory -- a task that fails to load *after* its files were
    read has already had whatever the exclusion was protecting against.
    """
    import json

    from gavel.tasks import load_manifest

    bank = json.loads(json.dumps(manifest.bank))
    held, kept = bank["tasks"][0]["task_id"], bank["tasks"][1]["task_id"]
    for entry in bank["tasks"]:
        # Absolute, so the copy can live anywhere: ``bank_root / path`` returns
        # the absolute path unchanged.
        entry["path"] = str(repo / entry["path"])
        entry["reference"] = str(repo / entry["reference"])
        if entry["task_id"] == held:
            entry["quarantined"] = True

    path = tmp_path / "manifest.json"
    path.write_text(json.dumps(bank))
    loaded = load_manifest(path)
    assert kept in loaded.tasks
    assert held not in loaded.tasks
