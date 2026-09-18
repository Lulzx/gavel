"""Shared fixtures.

Tests that need the real Bend checker are marked ``checker``: they are the only
ones that shell out, and they are the only ones that can be slow or unavailable
on a machine without the vendored toolchain. ``pytest -m "not checker"`` runs
the rest in milliseconds.
"""

from __future__ import annotations

from pathlib import Path

import pytest

from gavel.tasks import Task

REPO = Path(__file__).resolve().parents[1]

FIXTURE_TASK = "t1-add-succ"

FIXTURE_LAWS = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding a successor on the right is the successor of adding.
law add_succ:
  for x: Nat
  for y: Nat
  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
"""

FIXTURE_STUB = """\
import Base

# TODO(policy): implement. Recurse on `a`, so `add(x, 1n+y)` reduces to
# `1n + add(x, y)` in the step.
def add(a: Nat, b: Nat) -> Nat:
  ?TODO
"""


def pytest_configure(config: pytest.Config) -> None:
    config.addinivalue_line(
        "markers", "checker: exercises the real Bend checker (slow)")


@pytest.fixture(scope="session")
def repo() -> Path:
    return REPO


@pytest.fixture(scope="session")
def toolchain():
    from gavel.toolchain import Toolchain
    return Toolchain.load()


@pytest.fixture(scope="session")
def manifest():
    from gavel.tasks import load_manifest
    return load_manifest(REPO / "manifest.json")


@pytest.fixture(scope="session")
def task(manifest) -> Task:
    return manifest.get(FIXTURE_TASK)


@pytest.fixture(scope="session")
def header(task) -> str:
    return task.proof_header


@pytest.fixture
def submission(task) -> dict[str, str]:
    """A submission that clears the gate. It need not type-check."""
    return {
        "solution.bend": FIXTURE_STUB,
        "PROOF.bend": task.proof_header + "\ndef L.add_succ(x, y):\n  ?TODO\n",
    }


@pytest.fixture
def make_task():
    """Build a Task without touching the filesystem."""

    def build(**over) -> Task:
        meta = {"task_id": "t-fake", "tier": 1, "laws": ["add_succ"],
                "policy_targets": ["add"], "hashes": {}}
        meta.update(over.pop("meta", {}))
        fields = dict(
            task_id="t-fake", tier=1, root=REPO, references=REPO, prompt="",
            laws_src=FIXTURE_LAWS, prelude_src="import Base\n",
            stub_src=FIXTURE_STUB, meta=meta, hash="")
        fields.update(over)
        return Task(**fields)

    return build
