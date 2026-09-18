"""The mutation rules, as source transformations. No checker, no filesystem.

A rule that produces a file identical to the reference is the failure mode
worth guarding: it looks like a mutant, it costs a checker run, and it proves
nothing because it *is* the answer.
"""

from __future__ import annotations

import pytest

from tools.mutate import Mutant, _unique_names, dedupe, mutants_of

ADD = """\
import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
"""

APPEND = """\
import Base

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
"""


def by_rule(src: str, rule: str) -> list[Mutant]:
    return [m for m in mutants_of(src) if m.rule == rule]


def test_every_mutant_differs_from_the_reference():
    for src in (ADD, APPEND):
        for mutant in mutants_of(src):
            assert mutant.source.strip() != src.strip(), mutant.name


def test_mutants_keep_the_definition_they_are_mutating():
    for mutant in mutants_of(ADD):
        assert "def add(" in mutant.source
        assert mutant.source.startswith("import Base")


def test_the_def_is_not_lost_when_the_body_is_rewritten():
    """A rule that dropped the def would produce a file that cannot check."""
    for mutant in mutants_of(APPEND):
        assert "def append(" in mutant.source
        assert mutant.source.count("def ") == 1


# --- the individual rules -------------------------------------------------------

def test_swap_case_bodies_keeps_the_patterns_and_moves_the_answers():
    mutant = by_rule(ADD, "swap-case-bodies")[0]
    assert "case 0n:" in mutant.source
    assert "case 1n+p:" in mutant.source
    # The zero case now returns the recursive answer, and vice versa.
    assert mutant.source.index("case 0n:") < mutant.source.index("1n + add(p, b)")


def test_constant_body_gives_every_input_the_base_answer():
    mutant = by_rule(ADD, "constant-body")[0]
    assert mutant.source.count("      b") == 2
    assert "add(p, b)" not in mutant.source


def test_tail_to_whole_recurses_on_the_list_instead_of_its_tail():
    mutant = by_rule(APPEND, "tail-to-whole")[0]
    assert "append(xs, ys)" in mutant.source
    assert "h <> append(xs, ys)" in mutant.source


def test_tail_to_whole_does_not_apply_to_a_nat_match():
    assert by_rule(ADD, "tail-to-whole") == []


def test_swap_call_arguments_swaps_only_plain_identifier_pairs():
    mutant = by_rule(ADD, "swap-call-arguments")[0]
    assert "add(b, p)" in mutant.source
    # A call with a compound argument is left alone, not half-swapped.
    assert by_rule("""\
def f(a: Nat, b: Nat) -> Nat:
  g(1n + a, b)
""", "swap-call-arguments") == []


def test_recursion_to_parameter_replaces_the_argument_it_recurred_on():
    """`add(p, b)` recursed on `p`; both arguments get a chance to be wrong."""
    mutants = by_rule(ADD, "recursion-to-parameter")
    assert [m.name for m in mutants] == ["add-recursion-arg0-to-param-5",
                                         "add-recursion-arg1-to-param-5"]
    assert "add(a, b)" in mutants[0].source
    assert "add(p, a)" in mutants[1].source


def test_recursion_to_parameter_needs_a_recursive_call():
    assert by_rule("""\
def f(a: Nat) -> Nat:
  a
""", "recursion-to-parameter") == []


def test_drop_last_case_removes_the_recursive_branch():
    mutant = by_rule(ADD, "drop-last-case")[0]
    assert "case 0n:" in mutant.source
    assert "case 1n+p:" not in mutant.source
    assert mutant.strong is False


def test_nat_base_off_by_one_moves_the_zero_case():
    mutant = by_rule(ADD, "nat-base-off-by-one")[0]
    assert "case 1n:" in mutant.source
    assert "case 0n:" not in mutant.source
    assert mutant.strong is False


def test_the_strong_flag_matches_whether_a_law_is_reached():
    """Weak mutants die before the type checker consults a law."""
    for mutant in mutants_of(ADD):
        assert mutant.strong == (mutant.rule not in
                                 {"drop-last-case", "nat-base-off-by-one"})


# --- bookkeeping ----------------------------------------------------------------

def test_policy_defs_are_left_alone():
    """Policy.* is the task's own helper, not the solution being tested."""
    src = """\
import Base

def Policy.helper(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      1n + Policy.helper(p)

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
"""
    assert all("Policy.helper" not in m.name for m in mutants_of(src))
    assert any(m.name.startswith("add-") for m in mutants_of(src))


def test_a_duplicate_is_dropped():
    mutants = mutants_of(ADD)
    assert len(dedupe(mutants + mutants, ADD)) == len(mutants)


def test_the_reference_itself_is_not_a_mutant():
    """A rule that happens to reproduce the reference must be dropped."""
    twin = Mutant("twin", "some-rule", ADD, strong=True)
    assert dedupe([twin], ADD) == []


def test_a_file_with_no_defs_yields_no_mutants():
    assert mutants_of("import Base\n") == []


# --- names, and the corpus they decide ------------------------------------------

NESTED = """\
import Base

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(k, t)
"""


def test_an_inner_match_is_not_read_as_a_case_of_the_outer_one():
    """The bug this pins produced a mutant of the wrong construct.

    ``_cases`` scans a line range, so the nested ``match xs:`` cases fall inside
    the outer ``match n:`` range. Reading them there replaces the list's tail
    with the *Nat* subject ``n`` -- a mutation of `drop` that no rule asked for
    -- and, worse, names it after the same line as the one the inner match
    legitimately produces.
    """
    tails = by_rule(NESTED, "tail-to-whole")
    assert len(tails) == 1
    assert "drop(k, xs)" in tails[0].source
    assert "drop(k, n)" not in tails[0].source


def test_two_mutants_never_share_a_name():
    """A name is a filename, and two of them are one file.

    ``write_mutants`` clears the directory and writes one file per mutant, so a
    collision silently loses one -- and the report still counts both, so V2
    measures a thinner corpus than the tool claims. The nesting bug above was
    how it was found; this is what stops the next one.
    """
    names = [m.name for m in mutants_of(NESTED)]
    assert len(set(names)) == len(names)


def test_a_collision_is_suffixed_rather_than_dropped():
    """Checked directly, because the fixture above no longer collides."""
    twins = [Mutant("add-rule-3", "r", ADD, strong=True),
             Mutant("add-rule-3", "r", APPEND, strong=True),
             Mutant("add-rule-3", "r", ADD + "\n", strong=True)]
    assert [m.name for m in _unique_names(twins)] == \
        ["add-rule-3", "add-rule-3-2", "add-rule-3-3"]
    assert len({m.source for m in _unique_names(twins)}) == 3
