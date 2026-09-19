"""The adversarial corpus: one payload per attack the gate claims to close.

SPEC.md 7.2 lists the constructs a submission may not contain. Each file under
``tests/adversarial/`` spells one of them -- or spells it in a way the scan must
*not* be fooled by, which is what the ACCEPT cases are for. A payload that
merely fails to type-check would be at tier 1 and prove nothing about the gate,
so every ACCEPT here is a submission the checker itself would accept.

This is the artifact to re-run against a new Bend version. Three of the cases
below record behaviour measured against 2.0.5 that is not obvious from the
grammar, and a bump that changes any of them should fail here rather than
quietly become a reward-hacking path.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

import pytest

from gavel.gate import check as gate_check
from gavel.tasks import LAWS_FILE, PRELUDE_FILE, PROOF_FILE, SOLUTION_FILE

CORPUS = Path(__file__).resolve().parent / "adversarial"

REJECT = "reject"
ACCEPT = "accept"


@dataclass(frozen=True)
class Case:
    file: str
    """Which submitted file carries the payload."""

    verdict: str

    why: str
    """What the gate must do, and why. A claim about the checker names the
    measurement it came from."""


CASES: dict[str, Case] = {
    # --- @unsafe ---------------------------------------------------------------
    "unsafe_on_a_proof_def": Case(
        PROOF_FILE, REJECT,
        "@unsafe switches off the termination checker, so a self-call "
        "type-checks; the checker exits 0 and prints a warning instead of the "
        "success line"),
    "unsafe_on_a_policy_helper": Case(
        SOLUTION_FILE, REJECT,
        "the reserved helper namespace is still a file the gate scans"),
    "unsafe_with_a_space_after_the_at": Case(
        PROOF_FILE, REJECT,
        "the decorator is three tokens, and the scan matches tokens"),
    "unsafe_after_a_clean_def": Case(
        SOLUTION_FILE, REJECT,
        "the scan reads every declaration, not just the first"),
    "unsafe_spelled_in_uppercase": Case(
        PROOF_FILE, ACCEPT,
        "the gate matches the word case-sensitively, and so does the checker: "
        "'@UNSAFE' fails to parse with \"expected 'unsafe' (the one decorator)\""),
    "unsafe_used_as_a_hole_name": Case(
        SOLUTION_FILE, ACCEPT,
        "?unsafe is one hole token, not an @ and a name"),
    "unsafe_word_inside_a_string": Case(
        PROOF_FILE, ACCEPT,
        "literal bodies are not decls; the scan runs on the token stream"),
    "unsafe_word_inside_a_comment": Case(
        PROOF_FILE, ACCEPT, "a comment is not a decl"),
    # --- law -------------------------------------------------------------------
    "a_law_redeclared_in_the_proof": Case(
        PROOF_FILE, REJECT, "a submission may not restate the spec it is judged by"),
    "a_law_the_task_does_not_declare": Case(
        PROOF_FILE, REJECT,
        "a law the task never declared is a name no submission may introduce"),
    "a_law_declared_in_the_solution": Case(
        SOLUTION_FILE, REJECT, "the solution is scanned too"),
    "a_law_named_under_the_policy_namespace": Case(
        PROOF_FILE, ACCEPT,
        "Policy.* is an allowed namespace; the credit path is what ignores it, "
        "since law_definitions resolves names through the file's own aliases "
        "and Policy is not one of them"),
    "a_law_declaration_inside_a_comment": Case(
        PROOF_FILE, ACCEPT, "a commented-out law is not a declaration"),
    "the_word_law_inside_a_string": Case(
        PROOF_FILE, ACCEPT, "nor is a law spelled inside a literal"),
    # --- imports ---------------------------------------------------------------
    "an_import_of_another_file": Case(
        PROOF_FILE, REJECT, "only Base and the task's own files may be imported"),
    "an_import_that_reaches_a_sibling_task": Case(
        PROOF_FILE, REJECT,
        "a path out of the task directory is the same hole as any other"),
    "an_import_of_an_absolute_path": Case(
        PROOF_FILE, REJECT, "an absolute path is outside the task by construction"),
    "an_import_of_a_hub_package": Case(
        PROOF_FILE, REJECT,
        "a hub import fetches code over the network and pins it to a hash the "
        "policy chose"),
    "an_import_of_base_under_an_alias": Case(
        SOLUTION_FILE, REJECT,
        "aliasing Base is not importing Base, and every other path is refused"),
    "a_bare_import_line": Case(
        PROOF_FILE, REJECT,
        "the loader reads imports per line, so a line that is only 'import' is "
        "malformed rather than absent"),
    "a_foreign_effect_import": Case(
        SOLUTION_FILE, REJECT,
        "import \"x.c\" declares a foreign effect and escapes the type system"),
    "a_foreign_effect_import_inside_a_body": Case(
        SOLUTION_FILE, REJECT,
        "the same declaration inside a def body; this one is found on the token "
        "stream, since the loader reads only the header"),
    "a_top_level_import_after_a_declaration": Case(
        SOLUTION_FILE, REJECT,
        "the gate scans every line of the file, so it sees this even though "
        "book_load, which stops at the first declaration, does not"),
    "a_buried_import_of_base": Case(
        SOLUTION_FILE, ACCEPT,
        "the one import the gate would allow anywhere; measured against 2.0.5 "
        "the checker refuses a top-level import after a declaration with "
        "\"expected 'def', 'type' or 'law'\", so nothing is smuggled"),
    "the_laws_file_under_two_aliases": Case(
        PROOF_FILE, ACCEPT,
        "both paths are allowed, and measured against 2.0.5 the checker accepts "
        "the second alias: book_load namespaces a file by its path, not by the "
        "alias it was bound to"),
    "an_import_line_inside_a_comment": Case(
        PROOF_FILE, ACCEPT, "the line-head scan sees a '#', not an import"),
    "a_multiline_string_spelling_an_import": Case(
        PROOF_FILE, ACCEPT,
        "measured against 2.0.5 the checker accepts a string spanning lines "
        "(\"a\" newline \"b\" prints as a\\nb), so a line inside one is inert -- "
        "the loader stops at the first declaration before reaching it. The scan "
        "blanks such a literal for that reason"),
    # --- main ------------------------------------------------------------------
    "a_main_in_the_solution": Case(
        SOLUTION_FILE, REJECT,
        "a main runs during checking: its output replaces the success line and "
        "the file exits 0 having proved nothing"),
    "a_main_in_the_proof": Case(
        PROOF_FILE, REJECT,
        "the same hole in the other submitted file; the name rule also refuses "
        "it, since main is neither a target nor a law"),
    "the_word_main_inside_a_comment": Case(
        PROOF_FILE, ACCEPT, "a comment does not declare anything"),
    "main_used_as_a_hole_name": Case(
        SOLUTION_FILE, ACCEPT, "?main is a hole, and the file declares no main"),
    # --- names -----------------------------------------------------------------
    "a_helper_outside_the_policy_namespace": Case(
        SOLUTION_FILE, REJECT,
        "an unqualified helper could shadow a prelude or Base name; helpers go "
        "under Policy.* so the allowlist stays checkable"),
    "a_type_declared_by_the_submission": Case(
        SOLUTION_FILE, REJECT, "type declarations are held to the same allowlist"),
    "a_def_qualified_by_the_prelude": Case(
        SOLUTION_FILE, REJECT,
        "the prelude belongs to the task; a def under its namespace is a "
        "redefinition of the task's own file"),
    "a_proof_for_a_law_that_does_not_exist": Case(
        PROOF_FILE, REJECT,
        "a proof of an invented law would be credited to nothing, and the name "
        "is outside the allowlist"),
    "a_proof_under_the_wrong_module": Case(
        PROOF_FILE, REJECT,
        "L is not bound in this file, so the def proves no law of this task"),
    "a_proof_without_a_module_qualifier": Case(
        PROOF_FILE, REJECT,
        "an unqualified add_plus is a new top-level name, not the law's proof"),
    "a_proof_under_an_alias_the_submission_chose": Case(
        PROOF_FILE, ACCEPT,
        "the alias the submission writes is the one the name is resolved "
        "through, which is how the checker resolves it too"),
    "a_target_defined_twice": Case(
        SOLUTION_FILE, ACCEPT,
        "both defs are the target's own name; duplicate detection belongs to "
        "the checker's parser, and the last def wins for the gate's scan"),
    "a_hole_left_in_the_target": Case(
        SOLUTION_FILE, ACCEPT,
        "the stub itself: a hole is not a forbidden construct, it is a "
        "submission that has not been written yet"),
    # --- what the lexer cannot read ---------------------------------------------
    "an_unterminated_string_literal": Case(
        SOLUTION_FILE, REJECT,
        "the gate's lexer stops at an unterminated literal; the file is refused "
        "as unparsable rather than raising out of the check and losing the turn"),
    "an_unterminated_char_literal": Case(
        PROOF_FILE, REJECT, "the same rule for a character literal"),
    # --- the file set ----------------------------------------------------------
    "the_laws_file_submitted_back": Case(
        LAWS_FILE, REJECT,
        "the task's own files are immutable; the payload here is a placeholder "
        "-- the finding is about the name, whatever the file says"),
    "the_prelude_submitted_back": Case(
        PRELUDE_FILE, REJECT, "the same rule for the prelude"),
}


@pytest.mark.parametrize("name", sorted(CASES))
def test_the_corpus(name, task):
    case = CASES[name]
    files = {SOLUTION_FILE: task.stub_src, PROOF_FILE: task.proof_header + "\n"}
    files[case.file] = (CORPUS / f"{name}.bend").read_text()
    result = gate_check(task, files)
    if case.verdict == REJECT:
        assert not result.ok, f"{name}: the gate passed a payload it must refuse"
    else:
        assert result.ok, f"{name}: {[str(f) for f in result.findings]}"


def test_every_payload_is_a_case_and_every_case_is_a_payload():
    """A file nobody asserts on is a file nobody runs."""
    on_disk = {path.stem for path in CORPUS.glob("*.bend")}
    assert on_disk == set(CASES)


def test_the_corpus_is_bigger_than_the_rule_list():
    """SPEC.md 7.2 is seven rows; the corpus is what those rows mean in practice."""
    assert len(CASES) >= 30
    assert sum(1 for case in CASES.values() if case.verdict == ACCEPT) >= 10
