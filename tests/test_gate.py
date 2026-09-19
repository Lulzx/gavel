"""The gate, as a list of the ways a policy might try to cheat.

Each test is an attack. The gate's whole job is that these fail; a regression
here is a reward-hacking path, so the tests are written against the *finding
code*, not against a boolean, so that a submission rejected for the wrong
reason is visible.
"""

from __future__ import annotations

import pytest

from gavel.gate import GatePolicy, check
from gavel.hashing import sha256_text
from gavel.tasks import LAWS_FILE, PRELUDE_FILE, PROOF_FILE, SOLUTION_FILE

HEADER = ("import Base\nimport ./prelude.bend as P\n"
          "import ./solution.bend as S\nimport ./LAWS.bend as L\n")


def codes(result) -> list[str]:
    return sorted(f.code for f in result.findings)


def test_a_clean_submission_clears_the_gate(task, submission):
    result = check(task, submission)
    assert result.findings == ()
    assert result.ok
    assert dict(result.hashes)[SOLUTION_FILE] == sha256_text(submission[SOLUTION_FILE])


# --- the checker's own holes -------------------------------------------------

def test_unsafe_is_rejected_on_its_own_line(task, submission):
    submission[PROOF_FILE] = HEADER + "\n@unsafe\ndef L.add_plus(x, y):\n  {==}\n"
    assert "unsafe" in codes(check(task, submission))


def test_unsafe_is_rejected_however_it_is_spaced(task, submission):
    # bend.ts:2540 skips whitespace between "@", "unsafe" and "def"
    submission[PROOF_FILE] = HEADER + "\n@ unsafe\ndef L.add_plus(x, y):\n  {==}\n"
    assert "unsafe" in codes(check(task, submission))


def test_a_submitted_main_is_rejected(task, submission):
    # A main in the submitted file runs: its side effects execute during
    # checking and its output replaces "All terms check." entirely.
    submission[SOLUTION_FILE] = ("import Base\n\n"
                                 "def main() -> u24:\n  return 0\n")
    assert "main" in codes(check(task, submission))


def test_a_policy_cannot_declare_a_law(task, submission):
    submission[PROOF_FILE] = HEADER + "\nlaw add_plus:\n  for x: Nat\n  {x == x : Nat}\n"
    assert "law" in codes(check(task, submission))


def test_a_foreign_import_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + '\ndef L.add_plus(x, y):\n  import "x.c"\n  {==}\n'
    assert "foreign-import" in codes(check(task, submission))


def test_a_hub_import_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + "import 0xdeadbeef/evil@abc\n"
    assert "hub-import" in codes(check(task, submission))


def test_importing_an_outside_file_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + "import ./elsewhere.bend\n"
    assert "import" in codes(check(task, submission))


def test_importing_a_sibling_task_file_is_rejected(task, submission):
    # ./prelude.bend and ./solution.bend are the task's; anything else is not.
    submission[PROOF_FILE] = HEADER + "import ./secret.bend\n"
    assert "import" in codes(check(task, submission))


# --- what the scan must not be fooled by -------------------------------------

def test_forbidden_words_inside_a_string_are_not_findings(task, submission):
    submission[SOLUTION_FILE] = (
        'import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n'
        '  "law @unsafe main import ./x.bend import 0x1/y"\n'
        '  a\n')
    assert codes(check(task, submission)) == []


def test_forbidden_words_inside_a_comment_are_not_findings(task, submission):
    submission[PROOF_FILE] = (
        HEADER + "\n# law @unsafe main\ndef L.add_plus(x, y):\n  ?TODO\n")
    assert codes(check(task, submission)) == []


def test_a_hole_named_unsafe_is_not_the_decorator(task, submission):
    # ?unsafe is a hole whose name happens to be "unsafe"
    submission[PROOF_FILE] = HEADER + "\ndef L.add_plus(x, y):\n  ?unsafe\n"
    assert codes(check(task, submission)) == []


# --- file set -----------------------------------------------------------------

def test_submitting_laws_is_rejected(task, submission):
    submission[LAWS_FILE] = task.laws_src
    assert "immutable-file" in codes(check(task, submission))


def test_submitting_the_prelude_is_rejected(task, submission):
    submission[PRELUDE_FILE] = task.prelude_src
    assert "immutable-file" in codes(check(task, submission))


def test_an_extra_file_is_rejected(task, submission):
    submission["extra.bend"] = "def x() -> Nat:\n  0n\n"
    assert "unknown-file" in codes(check(task, submission))


def test_missing_files_are_reported(task):
    assert "missing-file" in codes(check(task, {}))


def test_an_oversized_file_is_rejected(task, submission):
    submission[SOLUTION_FILE] = "import Base\n\n# " + "x" * 70_000 + "\n"
    assert "size" in codes(check(task, submission))
    assert check(task, submission, GatePolicy(max_file_bytes=1 << 20)).ok


# --- names ---------------------------------------------------------------------

def test_a_name_outside_the_target_list_is_rejected(task, submission):
    submission[SOLUTION_FILE] = ("import Base\n\ndef sub(a: Nat, b: Nat) -> Nat:\n  a\n")
    assert "name" in codes(check(task, submission))


def test_policy_helpers_are_allowed(task, submission):
    submission[PROOF_FILE] = HEADER + (
        "\ndef Policy.step(x: Nat) -> Nat:\n  x\n"
        "\ndef L.add_plus(x, y):\n  ?TODO\n")
    assert codes(check(task, submission)) == []


def test_a_proof_that_never_imports_the_laws_is_rejected(task, submission):
    """Measured 2026-09-20: an empty PROOF.bend checks, and a full run that
    checks was read as every law proven. A file that does not open the laws
    cannot discharge them, so the absence of the import is its own finding."""
    for proof in ("", "import Base\n",
                  "import Base\nimport ./solution.bend as S\n"):
        submission[PROOF_FILE] = proof
        assert "no-laws-import" in codes(check(task, submission)), repr(proof)


def test_a_law_proof_under_the_default_module_still_needs_the_import(task, submission):
    # ``LAWS`` is what an unaliased import would bind; naming it without the
    # import is a fresh def the checker would accept as anything.
    submission[PROOF_FILE] = "import Base\n\ndef LAWS.add_plus(x, y):\n  {==}\n"
    found = codes(check(task, submission))
    assert "no-laws-import" in found
    assert "name" in found


def test_a_proof_for_an_undeclared_law_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + "\ndef L.made_up(x):\n  {==}\n"
    assert "name" in codes(check(task, submission))


def test_a_proof_qualified_by_the_wrong_module_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + "\ndef X.add_plus(x, y):\n  {==}\n"
    assert "name" in codes(check(task, submission))


def test_an_unaliased_proof_name_is_rejected(task, submission):
    submission[PROOF_FILE] = HEADER + "\ndef add_plus(x, y):\n  {==}\n"
    assert "name" in codes(check(task, submission))


def test_an_alias_the_submission_chose_is_honoured(task, submission):
    # L is only the task's default; the name check resolves whatever alias the
    # submission actually bound, so a policy that renames it is not punished.
    submission[PROOF_FILE] = (
        "import Base\nimport ./LAWS.bend as Laws\n"
        "\ndef Laws.add_plus(x, y):\n  ?TODO\n")
    assert codes(check(task, submission)) == []


# --- the task's own integrity ---------------------------------------------------

def test_a_task_whose_recorded_hash_disagrees_is_rejected(make_task, submission):
    task = make_task(meta={"hashes": {"laws": "0" * 64}})
    assert "integrity" in codes(check(task, submission))


def test_a_task_with_no_recorded_hashes_is_not_second_guessed(make_task, submission):
    assert check(make_task(), submission).ok


# --- every finding at once ------------------------------------------------------

def test_the_gate_reports_every_finding_not_just_the_first(task, submission):
    submission[PROOF_FILE] = (HEADER + "\n@unsafe\ndef main() -> u24:\n  return 0\n"
                              "law fake:\n  for x: Nat\n  {x == x : Nat}\n")
    found = codes(check(task, submission))
    assert "unsafe" in found
    assert "main" in found
    assert "law" in found


def test_an_unterminated_literal_is_a_finding_not_an_exception(task):
    """A stray quote used to raise LexError out of the gate, through
    check_submission and out of env.step, consuming the turn with no verdict."""
    files = {SOLUTION_FILE: task.stub_src + '\ndef Policy.z() -> String:\n  "abc\n',
             PROOF_FILE: task.proof_header + "\n"}
    result = check(task, files)
    assert not result.ok
    assert result.codes == ("unparsable",)
    assert result.findings[0].file == SOLUTION_FILE
    assert result.findings[0].line == 0 or result.findings[0].line > 1
