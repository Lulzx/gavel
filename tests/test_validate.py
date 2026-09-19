"""V1-V5, and the degenerate corpus that makes V3 worth running.

The tests that only build submissions are fast; the ones that hand them to the
checker are marked ``checker``.
"""

from __future__ import annotations

import json
import re
import shutil
from dataclasses import replace
from pathlib import Path

import pytest

from gavel.degenerate import _zero_of, corpus, laws_of, signatures, unmodelled
from gavel.reviews import REVIEWS_DIR, review_path
from gavel.tasks import HASH_KEYS, LAWS_FILE, PROOF_FILE, SOLUTION_FILE
from gavel.validate import (TaskReport, bank_metrics, review_state,
                            validate_task)
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
    assert laws_of(task) == [("add_plus", [("x", "Nat"), ("y", "Nat")])]


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
                     "self-referential-unsafe",
                     "vary-add-to-double-a+reflexive-proof",
                     "vary-add-to-project-a+reflexive-proof",
                     "vary-add-to-double-b+reflexive-proof",
                     "vary-add-to-project-b+reflexive-proof",
                     "vary-add-to-zero+reflexive-proof"}


def test_the_corpus_varies_one_function_at_a_time(task):
    """Every argument-ignoring body, with the rest of the file at the reference.

    This family is the one that caught ``t1-add-plus``'s predecessor. Its law
    was ``add(x, 1n+y) == 1n + add(x, y)``, which the projection onto the
    *second* argument satisfies -- ``add(a, b) = b`` makes the goal ``1n+y ==
    1n+y`` -- while the whole-solution attempts above only ever projected onto
    the first, so the task validated clean and paid reward 1.0 for a function
    nobody had written.

    The second projection is the point: a family that only tried ``project-a``
    would have reported the same task pinned.
    """
    varied = {a.name for a in corpus(task) if a.name.startswith("vary-")}
    assert varied == {"vary-add-to-double-a+reflexive-proof",
                      "vary-add-to-project-a+reflexive-proof",
                      "vary-add-to-double-b+reflexive-proof",
                      "vary-add-to-project-b+reflexive-proof",
                      "vary-add-to-zero+reflexive-proof"}
    # A reusable binder is declared with `+` in the stub, and that `+` is not
    # part of the name: a body rebuilt from it reads `+b + +b`, fails to
    # type-check, and leaves the attempt proving nothing while looking like a
    # check.
    double_b = next(a for a in corpus(task)
                    if a.name == "vary-add-to-double-b+reflexive-proof")
    body = double_b.files[SOLUTION_FILE]
    assert "def add(a: Nat, +b: Nat) -> Nat:\n  b + b" in body


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
    # The prelude is elaborated by every book in the task, so it is checked
    # first: one run, before V1 pays for the reference.
    assert report.checked[:2] == ["prelude", "reference"]
    assert "degenerate:reference+holed-proof" in report.checked
    assert report.mutant_tiers and all(t != TIER_COMPLETE for t in report.mutant_tiers)


def test_strict_promotes_an_unmeasured_quantity_to_a_failure(task, toolchain):
    assert validate_task(task, toolchain, strict=True).valid is False


def test_the_report_serialises(task, toolchain):
    blob = validate_task(task, toolchain).to_json()
    assert blob["task_id"] == task.task_id
    assert blob["valid"] is True
    assert blob["laws"] == list(task.laws)


def test_validating_in_parallel_gives_the_same_verdicts(capsys):
    """``--jobs`` is a speed knob, not a second code path with its own answers.

    The bank outgrew a serial pass -- 58 tasks took over 18 minutes in CI -- and
    the speedup is only sound if a task's verdict does not depend on what else
    was running. The timings are expected to differ; ``reference_ms`` is what
    V4 measures, which is exactly why ``--jobs`` is off by default.
    """
    from tools.validate import main
    ids = ["t1-add-plus", "t1-len-append"]

    def reports(jobs: int) -> dict:
        assert main([*ids, "--json", "--jobs", str(jobs)]) == 0
        out = capsys.readouterr().out
        # Decoding the whole stream is the assertion, not a convenience: the
        # summary lines used to follow the document, so ``--json`` existed for
        # callers who could not parse it. SPEC 12's bank block is exported here
        # and a reader has to be able to load it.
        blob = json.loads(out)
        return {t["task_id"]: t for t in blob["tasks"]}

    serial, parallel = reports(1), reports(2)
    for task_id in ids:
        for field in ("valid", "tier", "laws", "hash", "problems", "warnings",
                      "checked", "mutant_tiers", "mutant_strong", "mutant_kills",
                      "review"):
            assert serial[task_id][field] == parallel[task_id][field], field


# --- V3 is not vacuous ----------------------------------------------------------

REFLEXIVE_LAWS = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S

# A law that holds by definition -- a task nobody should have published.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(S.add(x, y), x) == S.add(S.add(x, y), x) : Nat}
"""

REFLEXIVE_PROOF = """\
import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.add_plus(x, y):
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


# --- the prelude is a file, and it has to compile ------------------------------

def test_a_prelude_that_does_not_type_check_is_a_problem(make_task, toolchain, task):
    """A Lone binder used twice, which is what actually shipped twice.

    The prelude is imported by the task's own laws, so it is elaborated in every
    book in the task. Without this check the first symptom is V1 reporting that
    the *reference* is tier 1, and the Location that names the prelude is a few
    lines into a diagnostic nobody reads that far down.
    """
    broken = ("import Base\n\n"
              "def P.double_all(xs: List<Nat>) -> List<Nat>:\n"
              "  match xs:\n"
              "    case Nil{}:\n"
              "      Nil{}\n"
              "    case h <> t:\n"
              "      (h + h) <> P.double_all(t)\n")
    report = validate_task(make_task(prelude_src=broken, references=task.references),
                           toolchain)
    assert any(problem.startswith("prelude:") for problem in report.problems)
    assert "consumed more than once" in " ".join(report.problems)
    assert "prelude" in report.checked


def test_a_task_whose_laws_never_call_the_prelude_still_pays_for_it(
        make_task, toolchain, task):
    """The reason the check exists rather than being folded into V1.

    No law here mentions ``P.double_all``, so nothing in the task's text says
    the prelude matters -- and every book in the task still fails, because the
    checker elaborates what the law file imports.
    """
    broken = ("import Base\n\n"
              "def P.unused(x: Nat) -> List<Nat>:\n"
              "  match 1n:\n"
              "    case 1n:\n"
              "      x <> x <> Nil{}\n")
    report = validate_task(make_task(prelude_src=broken, references=task.references),
                           toolchain)
    assert any(problem.startswith("prelude:") for problem in report.problems)


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

law add_plus:
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
            "law add_plus:\n"
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


# --- review: a judgement the pipeline must not be able to write ----------------
#
# The bank's M4 line says human-reviewed laws are "not satisfied, and the bank
# says it is". It said that because eleven tier-3 tasks carried a record no
# human wrote -- written by the authoring pipeline itself through a flag -- and
# three of those records had gone stale when the same day's repairs edited
# LAWS.bend under them. Nothing noticed the second half. These pin the states,
# the severity, and the one that is a structural property rather than a value:
# the record lives in a directory no tool here writes.

def _write_review(task, record) -> None:
    """Put a record where ``Task.review`` looks for one."""
    path = review_path(task.repo, task.task_id)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(record, indent=2) + "\n")


@pytest.fixture
def movable_task(task, tmp_path):
    """The real fixture task, with its reference directory somewhere writable.

    ``Task.repo`` is derived from ``references``, so a Task that keeps the real
    one reads its records out of the repository -- and a test that writes a
    review into the bank it is testing has changed the thing it is measuring.
    Copied instead, which also means the assertion "there is no record" is about
    this test's directory rather than about whatever the bank happens to hold.
    """
    shutil.copytree(task.references, tmp_path / "references" / task.task_id)
    return replace(task, references=tmp_path / "references" / task.task_id)


def test_a_review_below_the_tier_needs_no_record(make_task):
    """Tier 1 and 2 are reviewed by the author's own reading, so an absent
    record there is the design rather than a gap."""
    assert review_state(make_task(tier=2).meta, 2) == "none-needed"


def test_a_review_at_the_tier_with_no_record_is_unreviewed(movable_task, toolchain):
    """The honest state, and the one the 39 tier-3-and-above tasks are in: it
    must be reported, and it must not read as a defect.

    Run on the real fixture task rather than a built one so that ``valid`` means
    something: a fabricated task fails V2 for having no mutants, and the
    assertion would pass for a reason that has nothing to do with review.
    """
    reviewless = replace(movable_task, tier=3)
    assert reviewless.review is None
    assert review_state(reviewless.meta, 3) == "unreviewed"
    report = validate_task(reviewless, toolchain)
    assert report.review == "unreviewed"
    assert any("no review record" in warning for warning in report.warnings)
    assert not any("review" in problem for problem in report.problems)


def test_a_review_whose_hashes_match_is_current(make_task):
    """What the check actually witnesses: the record covers these laws.

    It still says nothing about who wrote the file, and the move to
    ``reviews/`` did not give it that -- what it gave it is that the pipeline
    can no longer *create* the file. So the state stays ``current`` and does not
    become ``approved``: on the bank this state read 8 of 39 while the flag
    existed, every one of those eight written by the agent that also wrote the
    task, against a human-reviewed figure of 0."""
    hashes = {"laws": "aaa", "prelude": "bbb"}
    task = make_task(tier=3, meta={"hashes": hashes})
    assert review_state(task.meta, 3, {"by": "lulzx", "hashes": hashes}) == "current"


def test_a_review_whose_hashes_have_moved_is_stale_and_still_valid(movable_task,
                                                                   toolchain):
    """``t3-pad``, ``t3-rev-rev`` and ``t3-zip-sum`` were in exactly this state.

    Only the *recorded* side can drift, and that is what makes the state worth
    naming: ``meta["hashes"]`` is gate-enforced against the shipped ``LAWS.bend``
    and ``prelude.bend``, so a task whose immutable files were edited without a
    republish fails the integrity check on every submission instead. Editing a
    law and republishing, which is what the repair procedure does, moves
    ``meta["hashes"]`` and leaves the record behind -- silently, until this check.

    The severity is the other assertion that matters. The record attests to laws
    the task does not ship, which is worth saying out loud -- and it is not a
    defect in the reward function, which is what ``problems`` are about, so the
    task stays valid and a green build does not become a claim about whether
    anyone read the laws. A word used here and in ``tools/author.py``, which
    blocks at the checkpoint on the same condition; two copies of "is this
    review stale" would be two answers to one question.
    """
    recorded = dict(movable_task.meta["hashes"])
    recorded[HASH_KEYS[LAWS_FILE]] = "0" * 64
    _write_review(movable_task, {"by": "lulzx", "hashes": recorded})
    stale = replace(movable_task, tier=3)
    assert review_state(stale.meta, 3, stale.review) == "stale"
    report = validate_task(stale, toolchain)
    assert report.review == "stale"
    assert report.valid, report.problems
    assert any("no longer match" in warning for warning in report.warnings)


def test_the_review_check_reads_the_hashes_pair_not_the_task_hash(make_task):
    """``Task.hash`` folds in ``solution.bend`` and is a string; the review was
    taken over ``meta["hashes"]``, which is the pair of source hashes. Comparing
    the wrong one can only ever disagree, so every task would read stale."""
    hashes = {"laws": "aaa", "prelude": "bbb"}
    task = make_task(tier=3, hash="not-a-pair", meta={"hashes": hashes})
    assert review_state(task.meta, 3, {"by": "lulzx", "hashes": hashes}) == "current"


def test_a_record_the_pipeline_cannot_write_is_read_from_the_reviews_directory(
        movable_task):
    """The structural half of Fact 27, and the reason the record moved.

    The record used to be a ``"reviewed"`` key in ``meta.json``, which
    ``tools/publish.py`` rewrites on every publish and which
    ``tools/author.py --reviewer`` could therefore set. A record that lives in
    ``meta.json`` is a record the pipeline can forge; one that lives beside the
    manifest in ``reviews/`` is a file nothing here opens for writing, so the
    only way it appears is that someone put it there.

    Both halves are asserted, because the second is what makes the first mean
    anything: the key in ``meta.json`` is now inert, and the file is what counts.
    """
    tier_three = replace(movable_task, tier=3)
    tier_three.meta["reviewed"] = {"by": "lulzx",
                                   "hashes": tier_three.meta["hashes"]}
    assert review_state(tier_three.meta, 3, tier_three.review) == "unreviewed", \
        "a reviewed key in meta.json must not read as a record any more"

    _write_review(movable_task, {"by": "lulzx",
                                 "hashes": movable_task.meta["hashes"]})
    assert review_state(tier_three.meta, 3, tier_three.review) == "current"


def test_the_bank_ships_no_review_records_and_cannot_have_written_them():
    """Read the bank, and read the source that would have to write a record.

    Two claims, and the second is the one a value cannot make. The bank holds no
    review record -- the eleven the pipeline wrote for itself were removed when
    the flag was, rather than migrated to the new directory, because moving a
    forgery is not a repair. And no module under ``gavel/`` or ``tools/`` opens
    a path under ``reviews/`` for writing, so the directory can only gain a file
    from outside this repository.

    Both are checked against the working tree rather than a fixture: this is a
    statement about the code and the bank as shipped, which is exactly the kind
    of claim that rots quietly when it is only made in a docstring.
    """
    repo = Path(__file__).resolve().parent.parent
    shipped = sorted(p.stem for p in (repo / REVIEWS_DIR).glob("*.json")) \
        if (repo / REVIEWS_DIR).is_dir() else []
    assert shipped == [], f"the bank carries review records: {shipped}"

    writers = []
    for source in sorted((repo / "gavel").glob("*.py")) + \
            sorted((repo / "tools").glob("*.py")):
        for lineno, line in enumerate(source.read_text().splitlines(), 1):
            if REVIEWS_DIR not in line and "review_path" not in line:
                continue
            if re.search(r"write_text|open\([^)]*['\"]w|unlink|mkdir|touch", line):
                writers.append(f"{source.name}:{lineno}: {line.strip()}")
    assert writers == [], "a tool writes review records: " + "; ".join(writers)


# --- SPEC 12's environment-quality metrics, over a bank release ----------------

def _report(task_id, tier, laws, *, kills=None, review="none-needed", rate=None):
    """A TaskReport with only the fields the bank aggregate reads."""
    return TaskReport(task_id=task_id, tier=tier, laws=tuple(laws), hash="",
                      mutant_kills=dict(kills or {}), review=review,
                      zero_shot_solve_rate=rate)


def test_bank_metrics_counts_tasks_by_tier():
    metrics = bank_metrics([_report("a", 1, ["l"]), _report("b", 1, ["l"]),
                            _report("c", 4, ["l"])])
    assert metrics["tasks"] == 3
    assert metrics["tasks_by_tier"] == {"1": 2, "4": 1}


def test_a_law_no_mutant_kills_is_counted_at_zero(make_task):
    """The finding ``min`` exists for, and the bug this almost shipped with.

    Seeding from the corpora alone drops a law no mutant fails, which is the
    same information loss as a corpus that never touches it -- and it is the
    *dangerous* end of the distribution, so dropping it raises the mean and
    hides the law. Every law in the task is seeded, so the bank below reads
    mean 1.5 and min 0 over two laws rather than mean 3 over one.
    """
    metrics = bank_metrics([_report("t", 3, ["probed", "untouched"],
                                    kills={"probed": 3})])
    assert metrics["mutants_killed_per_law"] == {"mean": 1.5, "min": 0, "laws": 2}


def test_a_law_name_in_two_tasks_is_two_laws():
    """``add_plus`` is declared by several tasks. A mean over their sum is a
    mean over no declaration that exists, and the key says which one."""
    metrics = bank_metrics([_report("t1", 1, ["add_plus"], kills={"add_plus": 4}),
                            _report("t2", 3, ["add_plus"], kills={"add_plus": 6})])
    assert metrics["mutants_killed_per_law"] == {"mean": 5.0, "min": 4, "laws": 2}


def test_recorded_fraction_is_a_fraction_of_the_tasks_that_need_review():
    """Below ``REVIEW_TIER`` the author's reading *is* the review, so counting
    those tasks in the denominator would report a bank as unreviewed for
    following its own rule. The counts travel with the fraction so the
    denominator is never guessed at -- and they name the four states, so a
    reader is not asked to take a quotient as a statement about review."""
    metrics = bank_metrics([
        _report("a", 3, ["l"], review="current"),
        _report("b", 3, ["l"], review="stale"),
        _report("c", 4, ["l"], review="unreviewed"),
        _report("d", 1, ["l"], review="none-needed")])
    assert metrics["review"] == {"current": 1, "stale": 1, "unreviewed": 1,
                                 "none-needed": 1, "needs_review": 3,
                                 "recorded_fraction": 0.3333}
    assert bank_metrics([_report("d", 1, ["l"])])["review"]["recorded_fraction"] is None


def test_bank_metrics_does_not_invent_a_calibration_number():
    """M4 item 4's blocked state, as a metric: zero recorded is reported as
    zero recorded and a null mean, not as a solve rate of 0.0."""
    metrics = bank_metrics([_report("a", 1, ["l"]), _report("b", 1, ["l"])])
    assert metrics["calibration"] == {"recorded": 0, "missing": 2,
                                      "mean_solve_rate": None}
    assert bank_metrics([_report("a", 1, ["l"], rate=0.5),
                         _report("b", 1, ["l"], rate=1.0)])["calibration"] == {
        "recorded": 2, "missing": 0, "mean_solve_rate": 0.75}
