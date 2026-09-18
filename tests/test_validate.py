"""V1-V5, and the degenerate corpus that makes V3 worth running.

The tests that only build submissions are fast; the ones that hand them to the
checker are marked ``checker``.
"""

from __future__ import annotations

from dataclasses import replace

import pytest

from gavel.degenerate import _zero_of, corpus, laws_of, signatures, unmodelled
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.validate import validate_task
from gavel.verdict import TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK

pytestmark = pytest.mark.checker


# --- the corpus is generated from the task, not hand-written per task ----------

def test_signatures_are_read_off_the_stub(task):
    assert signatures(task.stub_src) == [("add", [("a", "Nat"), ("b", "Nat")], "Nat")]


def test_signatures_skip_a_shape_they_do_not_understand():
    assert signatures("def f(x: Nat) -> Nat:\n  x\n") == [("f", [("x", "Nat")], "Nat")]
    assert signatures("def f(x) -> Nat:\n  x\n") == []      # no annotations
    assert signatures("type Foo\n") == []


def test_a_comma_inside_a_type_does_not_split_the_parameter_list():
    """The bug this pins cost V3 its meaning on every task spelled this way.

    Splitting on a bare comma turns ``List<&2, Nat>`` into a parameter of type
    ``List<&2`` and a fragment with no type at all, so the def is dropped. The
    corpus then rebuilds a stub missing a function its laws call, every attempt
    is a type error, and V3 passes having tested nothing -- measured on
    ``t2-sum-laws``, which was rewritten rather than fixed at the time.
    """
    assert signatures("def sum(xs: List<&2, Nat>, ys: Nat) -> Nat:\n  xs\n") == \
        [("sum", [("xs", "List<&2, Nat>"), ("ys", "Nat")], "Nat")]
    assert signatures("def m(xs: List<List<Nat>>, n: Nat) -> List<Nat>:\n  xs\n") == \
        [("m", [("xs", "List<List<Nat>>"), ("n", "Nat")], "List<Nat>")]
    # A return type with a comma in it survives too.
    assert signatures("def p(a: Nat) -> List<&2, Nat>:\n  Nil{}\n") == \
        [("p", [("a", "Nat")], "List<&2, Nat>")]


def test_an_unparseable_stub_def_is_named_not_silently_dropped():
    """A corpus built from a partial parse is worse than no corpus, because it
    reports "fine"."""
    assert unmodelled("def f(x) -> Nat:\n  x\ndef g(a: Nat) -> Nat:\n  a\n") == ["f"]
    assert unmodelled("def g(a: Nat) -> Nat:\n  a\n") == []
    # A def with no parameters is parsed, not unmodelled.
    assert unmodelled("def k() -> Nat:\n  0n\n") == []


def test_the_bool_zero_is_a_value_not_a_constructor_name():
    """``Bool`` is ``False{}``/``True{}`` (base.bend:13). A generator emitting
    a bare ``False`` produces a submission that fails to type-check, so V3
    would have passed on every Bool-valued task without asking anything."""
    assert _zero_of("Bool") == "False{}"
    assert _zero_of("Nat") == "0n"
    assert _zero_of("List<Nat>") == "Nil{}"
    assert _zero_of("SomethingElse") is None


def test_law_binders_come_from_the_for_lines(task):
    assert laws_of(task) == [("add_succ", [("x", "Nat"), ("y", "Nat")])]


def test_a_two_binder_law_keeps_both_binders(manifest):
    two = manifest.get("t2-add-laws")
    assert laws_of(two) == [("add_zero", [("x", "Nat")]),
                            ("add_succ", [("x", "Nat"), ("y", "Nat")])]


def test_the_corpus_covers_the_ways_a_submission_can_be_empty(task):
    names = {attempt.name for attempt in corpus(task)}
    assert names == {"identity-solution+reflexive-proof",
                     "constant-solution+reflexive-proof",
                     "reference+reflexive-proof",
                     "reference+no-proof",
                     "reference+holed-proof",
                     "self-referential-unsafe"}


def test_every_degenerate_solution_is_crossed_with_a_real_proof(task):
    """Holding the proof fixed would miss a law that does not pin its function."""
    crossed = [a for a in corpus(task) if "solution+" in a.name]
    assert {a.name.split("+")[0] for a in crossed} == {"identity-solution",
                                                       "constant-solution"}


def test_a_degenerate_solution_is_well_typed_whatever_the_signature(manifest):
    """`len(xs: List<Nat>) -> Nat` cannot return `xs`.

    An attempt that fails to type-check is at tier 1 for a reason that has
    nothing to do with the laws, so V3 would pass without testing anything.
    """
    task = manifest.get("t1-len-append")
    identity = next(a for a in corpus(task)
                    if a.name.startswith("identity-solution"))
    body = identity.files[SOLUTION_FILE]
    assert "def len(xs: List<Nat>) -> Nat:\n  0n" in body
    assert "def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:\n  xs" in body


def test_a_generated_solution_does_not_import_itself(task):
    """The proof header names solution.bend; a solution carrying it would loop."""
    attempt = next(a for a in corpus(task)
                   if a.name.startswith("identity-solution"))
    solution = attempt.files[SOLUTION_FILE]
    assert SOLUTION_FILE not in solution
    assert "import Base" in solution
    assert "def add(a: Nat, b: Nat) -> Nat:" in solution


# --- the invariants -------------------------------------------------------------

def test_a_sound_task_passes_every_invariant(task, toolchain):
    report = validate_task(task, toolchain)
    assert report.valid, report.problems
    assert report.warnings == ["calibration: no zero_shot_solve_rate recorded"]
    assert report.reference_ms > 0
    assert report.checked[0] == "reference"
    assert "degenerate:reference+holed-proof" in report.checked
    assert report.mutant_tiers and all(t != TIER_COMPLETE for t in report.mutant_tiers)


def test_strict_promotes_an_unmeasured_quantity_to_a_failure(task, toolchain):
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
law add_succ:
  for x: Nat
  for y: Nat
  {S.add(S.add(x, y), x) == S.add(S.add(x, y), x) : Nat}
"""

REFLEXIVE_PROOF = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.add_succ(x, y):
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

law add_succ:
  for x: Nat
  for y: Nat
  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}

law never_proved:
  for x: Nat
  {S.add(x, 1n) == x : Nat}
"""


@pytest.fixture
def mutant_references(make_task, tmp_path, task):
    """A task whose ``mutants/`` directory the test fills in.

    Returns a builder so each test names its own corpus, since the invariant
    being checked is about the corpus and not about the task.
    """
    references = tmp_path / "references"
    (references / "mutants").mkdir(parents=True)
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.reference_proof)

    def build(mutants: dict[str, str]):
        for name, source in mutants.items():
            (references / "mutants" / f"{name}.bend").write_text(source)
        return make_task(references=references)

    return build


def test_v2_fails_when_a_mutant_still_proves_the_laws(mutant_references, toolchain,
                                                      task):
    """The mutant here *is* the reference, so it must trip V2."""
    made = mutant_references({"unmutated": task.reference_solution})
    report = validate_task(made, toolchain)
    assert any("V2" in problem and "still prove" in problem
               for problem in report.problems)
    assert "mutant:unmutated" in report.checked


def test_v2_fails_when_no_mutant_is_strong(mutant_references, toolchain):
    """A corpus of mutants that all die at tier 1 never exercises a law."""
    made = mutant_references(
        {"broken": 'import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  "no"\n'})
    report = validate_task(made, toolchain)
    assert any("V2" in problem and "type-checks" in problem
               for problem in report.problems)
    assert report.mutant_tiers == [TIER_NO_CHECK]


def test_v2_passes_when_a_mutant_is_caught(mutant_references, toolchain):
    made = mutant_references(
        {"constant": "import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  0n\n"})
    report = validate_task(made, toolchain)
    assert report.valid, report.problems
    assert report.mutant_tiers == [TIER_CHECKS]


def test_v2_fails_when_there_are_no_mutants_at_all(make_task, toolchain, task,
                                                   tmp_path):
    """A task whose reference has no mutants/ beside it is unguarded."""
    references = tmp_path / "bare"
    references.mkdir()
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.reference_proof)
    report = validate_task(make_task(references=references), toolchain)
    assert any("V2" in problem and "no mutants" in problem
               for problem in report.problems)


# --- V4 -------------------------------------------------------------------------

def test_the_latency_budget_is_configurable(task, toolchain):
    report = validate_task(task, toolchain, budget_ms=1)
    assert any("V4" in problem for problem in report.problems)


# --- the task is a problem before it is a reward function ----------------------

def test_a_task_with_no_prompt_is_not_valid(task, toolchain):
    """The failure this catches is silent: every other invariant passes.

    ``prompt.md`` is read with ``is_file()`` and falls back to the empty
    string, so a task with no problem statement is a perfectly good reward
    function -- and a policy is asked to prove a theorem it was never told.
    """
    report = validate_task(replace(task, prompt=""), toolchain)
    assert any("prompt.md" in problem for problem in report.problems)


def test_a_law_citing_something_the_stub_does_not_define(make_task, toolchain, task):
    """``S.len`` in a law whose stub offers only ``add``.

    The law file imports ``./solution.bend as S`` and the solution does not
    re-export the prelude, so this has to say ``P.len``. As written the checker
    answers "expected : a defined name / observed : S.len" pointing into the
    law, which reads like a proof that is wrong rather than a task that is --
    and the author of the law is the person least likely to read it that way.
    """
    laws = ("import Base\n"
            "import ./prelude.bend as P\n"
            "import ./solution.bend as S\n\n"
            "law add_succ:\n"
            "  for x: Nat\n"
            "  for y: Nat\n"
            "  {S.len(S.add(x, 1n+y)) == 1n+S.add(x, y) : Nat}\n")
    report = validate_task(make_task(laws_src=laws, references=task.references),
                           toolchain)
    assert any("S.len" in problem and "posed" in problem
               for problem in report.problems)


def test_a_comment_naming_the_prelude_is_not_a_citation(make_task, toolchain, task):
    """The bank's laws are heavily commented, so the scan strips comments
    first: a comment that mentions ``S.len`` while explaining the law is not a
    citation, and failing on one would make the check unusable."""
    laws = task.laws_src + "\n# not a citation: S.nonexistent would be P.nonexistent\n"
    report = validate_task(make_task(laws_src=laws, references=task.references),
                           toolchain)
    assert not any("S.nonexistent" in problem for problem in report.problems)
