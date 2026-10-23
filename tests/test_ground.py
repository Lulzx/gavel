"""Laws at points: the screen that separates "the laws reject this body" from
"the reference proof does not fit it".

``tests/holes/`` holds two bodies, each with a proof, that earned reward 1.000
against the law sets these tasks shipped with before ``gavel/ground.py``
existed. They are written in different tokens from the shipped mutants they
imitate, so the mutant tripwire did not withhold the reward. The tests rebuild
that law set by dropping the law that closed the hole, and pin both halves:
the screen calls each body a hole there, and rejects it under the laws the task
ships now.
"""

from __future__ import annotations

from dataclasses import replace
from pathlib import Path

import pytest

from gavel import ground
from gavel.check import check_submission
from gavel.laws import split_top_level
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.verdict import TIER_COMPLETE

HOLES = Path(__file__).resolve().parent / "holes"


def _without(task, law: str):
    """The task as it shipped before ``law`` was added to close a hole."""
    text = task.laws_src
    for chunk in split_top_level(text):
        if chunk.kind == "law" and chunk.name == law:
            text = text.replace(chunk.text, "")
    return replace(task, laws_src=text)


# --- reading laws: no checker ---------------------------------------------------

def test_binders_on_the_law_line_and_on_their_own_lines_read_the_same():
    one_line = ("law l: for xs: List<&2, Nat> for k: Nat "
                "{S.f(xs, k) == P.g(k <> xs) : Nat}\n")
    many = ("law l:\n  for xs: List<&2, Nat>\n  for k: Nat\n"
            "  {S.f(xs, k) == P.g(k <> xs) : Nat}\n")
    assert ground.parse_laws(one_line) == ground.parse_laws(many)
    (law,), unread = ground.parse_laws(many)
    assert unread == []
    assert law.data == (("xs", "List<&2, Nat>"), ("k", "Nat"))
    assert (law.goal.lhs, law.goal.rhs, law.goal.typ) == (
        "S.f(xs, k)", "P.g(k <> xs)", "Nat")


def test_an_equality_binder_is_a_hypothesis_not_a_value():
    src = ("law l:\n  for +x: Nat\n  for e: {P.le(x, 1n) == True{} : Bool}\n"
           "  {S.f(x) == x : Nat}\n")
    (law,), _ = ground.parse_laws(src)
    assert law.data == (("x", "Nat"),)
    assert law.hyps == (ground.Equation("P.le(x, 1n)", "True{}", "Bool"),)


def test_substitution_leaves_qualified_names_and_literals_alone():
    assert ground.substitute("P.n(n, 1n) + S.n", {"n": "2n"}) == "P.n((2n), 1n) + S.n"


def test_prelude_types_generate_their_constructors():
    adts = ground.prelude_types(
        "type Tree is Data:\n  Tip{}\n  Bin{l: Tree, key: Nat, r: Tree}\n")
    trees = ground.values(ground.parse_type("P.Tree", adts), adts)
    assert trees[0] == "P.Tip{}"
    assert "P.Bin{P.Tip{}, 0n, P.Tip{}}" in trees
    assert all(t.count("P.Bin") <= 3 for t in trees)


def test_a_sampled_plan_is_the_same_plan_twice():
    doms = [[f"{n}n" for n in range(9)]] * 3
    first = ground.assignments(["a", "b", "c"], doms, "law")
    assert first == ground.assignments(["a", "b", "c"], doms, "law")
    assert len(first) == ground.INSTANCE_CAP
    assert {"a": "0n", "b": "0n", "c": "0n"} in first


# --- against the checker --------------------------------------------------------

@pytest.mark.checker
def test_the_reference_satisfies_its_own_laws_at_every_point(manifest, toolchain):
    for name in ("t3-absdiff-comm", "t4-bst-insert", "t2-delete-laws"):
        task = manifest.get(name)
        report = ground.evaluate(task, toolchain, task.reference_solution)
        assert report.outcome == "equivalent", (name, report.error, report.violations)


@pytest.mark.checker
def test_the_absdiff_hole_found_by_hand_is_found_mechanically(manifest, toolchain):
    """``t3-absdiff-comm``'s fifth law was added after a person found a body
    that satisfies the other four. Without it the screen finds that body."""
    task = manifest.get("t3-absdiff-comm")
    body = ("import Base\nimport ./prelude.bend as P\n\n"
            "def absdiff(+a: Nat, +b: Nat) -> Nat:\n"
            "  (P.sub(a, b) + P.sub(b, a)) + (P.sub(a, b) + P.sub(b, a))"
            " * P.sub(a, P.sub(a, b))\n")
    assert ground.evaluate(_without(task, "absdiff_succ_succ"), toolchain,
                           body).outcome == "hole"
    assert ground.evaluate(task, toolchain, body).outcome == "rejected"


@pytest.mark.checker
@pytest.mark.parametrize("task_id, law, stem", [
    ("t2-sum-prefix-laws", "sum_prefix_step", "sum_prefix_whole_list"),
    ("t3-isort-perm", "insert_before", "isort_unsorted_tail"),
])
def test_a_body_that_was_paid_in_full_is_now_rejected(manifest, toolchain,
                                                      task_id, law, stem):
    task = manifest.get(task_id)
    body = (HOLES / f"{stem}.bend").read_text()
    old = task
    for name in ("sum_prefix_step", "insert_before", "insert_after", "isort_cons"):
        old = _without(old, name)
    assert ground.evaluate(old, toolchain, body).outcome == "hole"
    assert ground.evaluate(task, toolchain, body).outcome == "rejected"

    # And the proof that earned 1.000 against the old laws no longer does.
    verdict = check_submission(task, toolchain, {
        SOLUTION_FILE: body,
        PROOF_FILE: (HOLES / f"{stem}.proof.bend").read_text()})
    assert verdict.tier < TIER_COMPLETE
    assert law not in verdict.proven
