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
    assert sum(len(manifest.by_tier(t)) for t in (1, 2, 3)) == len(manifest)
