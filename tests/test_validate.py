"""V1-V5, and the degenerate corpus that makes V3 worth running.

The tests that only build submissions are fast; the ones that hand them to the
checker are marked ``checker``.
"""

from __future__ import annotations

import pytest

from gavel.degenerate import corpus, laws_of, signatures
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.validate import validate_task
from gavel.verdict import TIER_COMPLETE

pytestmark = pytest.mark.checker


# --- the corpus is generated from the task, not hand-written per task ----------

def test_signatures_are_read_off_the_stub(task):
    assert signatures(task.stub_src) == [("add", [("a", "Nat"), ("b", "Nat")], "Nat")]


def test_signatures_are_read_off_the_stub(task):
    assert signatures(task.stub_src) == [("add", [("a", "Nat"), ("b", "Nat")], "Nat")]


def test_signatures_skip_a_shape_they_do_not_understand():
    assert signatures("def f(x: Nat) -> Nat:\n  x\n") == [("f", [("x", "Nat")], "Nat")]
    assert signatures("def f(x) -> Nat:\n  x\n") == []      # no annotations
    assert signatures("type Foo\n") == []


def test_law_binders_come_from_the_for_lines(task):
    assert laws_of(task) == [("add_zero", [("x", "Nat")])]


def test_a_two_binder_law_keeps_both_binders(manifest):
    two = manifest.get("t2-add-laws")
    assert laws_of(two) == [("add_zero", [("x", "Nat")]),
                            ("add_succ", [("x", "Nat"), ("y", "Nat")])]


def test_the_corpus_covers_the_ways_a_submission_can_be_empty(task):
    names = {attempt.name for attempt in corpus(task)}
    assert names == {"identity-solution", "constant-solution", "reflexive-proof",
                     "self-referential-unsafe", "holed-proof"}


def test_a_generated_solution_does_not_import_itself(task):
    """The proof header names solution.bend; a solution carrying it would loop."""
    attempt = next(a for a in corpus(task) if a.name == "identity-solution")
    solution = attempt.files[SOLUTION_FILE]
    assert SOLUTION_FILE not in solution
    assert "import Base" in solution
    assert "def add(a: Nat, b: Nat) -> Nat:" in solution


# --- the invariants -------------------------------------------------------------

def test_a_sound_task_passes_every_invariant(task, toolchain):
    report = validate_task(task, toolchain)
    assert report.valid, report.problems
    assert report.warnings == ["V2: no mutants authored -- laws unguarded"]
    assert report.reference_ms > 0
    assert report.checked[0] == "reference"
    assert "degenerate:holed-proof" in report.checked


def test_strict_promotes_an_unchecked_invariant_to_a_failure(task, toolchain):
    assert validate_task(task, toolchain, strict=True).valid is False


def test_the_report_serialises(task, toolchain):
    blob = validate_task(task, toolchain).to_json()
    assert blob["task_id"] == task.task_id
    assert blob["valid"] is True
    assert blob["laws"] == list(task.laws)


# --- V3 is not vacuous ----------------------------------------------------------

REFLEXIVE_LAWS = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S

# A law that holds by definition -- a task nobody should have published.
law add_zero:
  for x: Nat
  {S.add(x, x) == S.add(x, x) : Nat}
"""

REFLEXIVE_PROOF = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.add_zero(x):
  {==}
"""


@pytest.fixture
def vacuous_task(make_task, tmp_path, task):
    """A task whose law is true of every solution, so nothing is being asked."""
    references = tmp_path / "references"
    references.mkdir()
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(REFLEXIVE_PROOF)
    return make_task(laws_src=REFLEXIVE_LAWS, references=references,
                     task_id="t-vacuous")


def test_a_law_that_holds_for_everything_fails_v3(vacuous_task, toolchain):
    report = validate_task(vacuous_task, toolchain)
    assert not report.valid
    assert any("V3" in problem for problem in report.problems)
    assert any("reflexive-proof" in problem for problem in report.problems)


def test_the_self_referential_attempt_is_the_gates_problem_not_the_checkers(
        task, toolchain):
    """Exit 0, and the gate is the only thing that stops it."""
    attempt = next(a for a in corpus(task) if a.must_be_gate_rejected)
    report = validate_task(task, toolchain)
    assert f"degenerate:{attempt.name}" in report.checked
    # It cleared the gate on this task, so V3 must not have flagged it: the
    # check that matters is that it cannot reach tier 4, which it cannot.
    from gavel.check import check_submission
    verdict = check_submission(task, toolchain, dict(attempt.files))
    assert verdict.tier != TIER_COMPLETE
    assert verdict.gate is not None and not verdict.gate.ok


# --- V5 -------------------------------------------------------------------------

UNSAFE_PRELUDE = "import Base\n\n@unsafe\ndef P.loop(x: Nat) -> Nat:\n  P.loop(x)\n"
FOREIGN_PRELUDE = "import Base\nimport ./someone_elses.bend as O\n"


def test_v5_catches_unsafe_in_a_task_file(make_task, toolchain, task, tmp_path):
    made = make_task(prelude_src=UNSAFE_PRELUDE, references=task.references)
    report = validate_task(made, toolchain)
    assert any("V5" in p and "@unsafe" in p for p in report.problems)


def test_v5_catches_an_import_from_outside_the_task(make_task, toolchain, task):
    made = make_task(prelude_src=FOREIGN_PRELUDE, references=task.references)
    report = validate_task(made, toolchain)
    assert any("V5" in p and "someone_elses" in p for p in report.problems)


# --- V1 and V2 ------------------------------------------------------------------

def test_v1_fails_when_the_reference_does_not_prove_everything(
        make_task, toolchain, task, tmp_path):
    references = tmp_path / "references"
    references.mkdir()
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.proof_header)   # no proof at all
    made = make_task(references=references)
    report = validate_task(made, toolchain)
    assert any("V1" in problem for problem in report.problems)
    assert not report.valid


def test_v1_notices_a_law_list_that_disagrees_with_the_checker(
        make_task, toolchain, task, tmp_path):
    """A law the file no longer declares is a reward for proving nothing."""
    made = make_task(laws_src=FIXTURE_LAWS_WITH_AN_EXTRA_LAW,
                     references=task.references)
    report = validate_task(made, toolchain)
    assert any("V1" in problem for problem in report.problems)


FIXTURE_LAWS_WITH_AN_EXTRA_LAW = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S

law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}

law never_proved:
  for x: Nat
  {S.add(x, 1n) == x : Nat}
"""


def test_v2_fails_when_a_mutant_still_proves_the_laws(
        make_task, toolchain, task, tmp_path):
    """The mutant dir holds the *reference* here, so it must trip V2."""
    references = tmp_path / "references"
    (references / "mutants").mkdir(parents=True)
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.reference_proof)
    (references / "mutants" / "unmutated.bend").write_text(task.reference_solution)

    made = make_task(references=references)
    report = validate_task(made, toolchain)
    assert any("V2" in problem for problem in report.problems)
    assert "mutant:unmutated" in report.checked
    assert not report.warnings


def test_v2_passes_when_a_mutant_is_caught(make_task, toolchain, task, tmp_path):
    references = tmp_path / "references"
    (references / "mutants").mkdir(parents=True)
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.reference_proof)
    # A solution that type-checks and is wrong -- exactly what a mutant is.
    (references / "mutants" / "constant.bend").write_text(
        "import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  0n\n")

    made = make_task(references=references)
    report = validate_task(made, toolchain)
    assert report.valid, report.problems
    assert not report.warnings


# --- V4 -------------------------------------------------------------------------

def test_the_latency_budget_is_configurable(task, toolchain):
    report = validate_task(task, toolchain, budget_ms=1)
    assert any("V4" in problem for problem in report.problems)
