"""What the static screens may claim about a law set.

No checker: these are properties of the reading, not of a task's soundness.
That distinction is the whole reason the module says a clean run is not a proof
-- a screen flags *room*, and only a body measures whether the room is used.
"""

from __future__ import annotations

import json

import pytest

from tools.screens import (
    anchors, applications, general, is_closed, is_literal, split_args,
)


@pytest.mark.parametrize("term", [
    "0n",
    "2n",
    "Nil{}",
    "True{}",
    "False{}",
    "1n <> (2n <> Nil{})",
])
def test_a_term_carrying_no_variable_is_literal(term):
    assert is_literal(term)


@pytest.mark.parametrize("term", [
    "xs",
    "1n + n",
    "x <> Nil{}",
    "Nat.double(n)",
    "Nat.sub(1n + n, 1n)",
    "S.fact(n)",
])
def test_a_term_carrying_a_variable_is_not_literal(term):
    assert not is_literal(term)


def test_a_constructor_name_is_not_read_as_a_variable():
    """The regression: the first ``is_literal`` matched the ``il`` inside
    ``Nil{}``, so every constructor counted as a variable and the screen
    flagged *nothing* -- bank-wide, silently, in the direction that hides
    holes. Anchoring the identifier pattern so it cannot start mid-word is the
    fix, and this is the assertion that keeps it fixed.
    """
    assert is_literal("Nil{}")
    assert is_literal("True{}")
    # A lowercase name that merely *contains* an uppercase one is still a name.
    assert not is_literal("someNil")


def test_split_args_respects_every_bracket():
    assert split_args("x <> xs, 1n + n, Nat.sub(1n + n, 1n)") == [
        "x <> xs", "1n + n", "Nat.sub(1n + n, 1n)",
    ]
    assert split_args("P.Bin{l, key, r}, True{}, k") == [
        "P.Bin{l, key, r}", "True{}", "k",
    ]


def test_applications_finds_the_call_and_its_arguments():
    found = applications("S.chunks(x <> xs, 1n + n)", "chunks")
    assert found == [["x <> xs", "1n + n"]]
    assert applications("S.facts(Nil{})", "facts") == [["Nil{}"]]
    assert applications("S.chunks(xs, n)", "facts") == []


def test_is_closed_reads_a_literal_or_a_nullary_constructor():
    assert is_closed("0n")
    assert is_closed("Nil{}")
    assert not is_closed("xs")
    assert not is_closed("1n + n")


def _task(tmp_path, name, stub, laws):
    """A task on disk plus a manifest that points at it by absolute path."""
    task = tmp_path / name
    task.mkdir()
    (task / "solution.bend").write_text(stub)
    (task / "LAWS.bend").write_text(laws)
    manifest = tmp_path / "manifest.json"
    manifest.write_text(json.dumps({
        "tasks": [{"task_id": name, "tier": 2, "path": str(task)}],
    }))
    return manifest


def test_general_flags_a_target_no_law_reaches_openly(tmp_path, capsys):
    """`chunks`'s shape: every law that names the target names a closed list,
    so no single law reaches the recursive branch with the arguments free."""
    manifest = _task(
        tmp_path, "t-flagged",
        stub="def chunks(xs: List<&2, Nat>, n: Nat) -> Nat:\n  ?TODO\n",
        laws="""\
law chunks_nil:
  for n: Nat
  {S.chunks(Nil{}, n) == 0n : Nat}
""",
    )
    assert general([], str(manifest)) == 0
    out = capsys.readouterr().out
    assert "t-flagged" in out
    assert "no general law" in out


def test_general_passes_a_law_that_reaches_the_target_openly(tmp_path, capsys):
    """The same target with one law stated at a variable: nothing to flag."""
    manifest = _task(
        tmp_path, "t-clean",
        stub="def chunks(xs: List<&2, Nat>, n: Nat) -> Nat:\n  ?TODO\n",
        laws="""\
law chunks_nil:
  for n: Nat
  {S.chunks(Nil{}, n) == 0n : Nat}

law chunks_cons:
  for x: Nat
  for xs: List<&2, Nat>
  for n: Nat
  {S.chunks(x <> xs, 1n + n) == S.chunks_go(xs, 1n + n, n, x <> Nil{}, Nil{}) : Nat}
""",
    )
    general([], str(manifest))
    out = capsys.readouterr().out
    assert "t-clean" not in out
    assert "flagged tasks: 0" in out


def test_anchors_flags_a_target_named_only_in_a_premise(tmp_path, capsys):
    """`t4-inorder-transport`'s shape. `g` is reached with every argument free,
    so `general` passes it -- but every occurrence sits in a `for e:` binder,
    and a submission that falsifies the premise makes that law vacuous."""
    manifest = _task(
        tmp_path, "t-premise",
        stub="def f(t: Nat) -> Nat:\n  ?TODO\n\ndef g(t: Nat) -> Bool:\n  ?TODO\n",
        laws="""\
law f_cond:
  for +t: Nat
  for e: {S.g(t) == True{} : Bool}
  {S.f(t) == 0n : Nat}
""",
    )
    assert anchors([], str(manifest)) == 0
    out = capsys.readouterr().out
    assert "[A] g: named only in a premise" in out
    # `f` is named on a goal's left and its right is `0n`, so it is anchored.
    assert "[A] f:" not in out and "[B] f:" not in out and "[C] f:" not in out


def test_anchors_flags_a_target_no_law_anchors_absolutely(tmp_path, capsys):
    """`t1-rev-append`'s shape. Every law naming `r` names it on both sides, so
    a body that post-composes a constant cancels on both sides of each."""
    manifest = _task(
        tmp_path, "t-relative",
        stub="def r(xs: List<Nat>) -> List<Nat>:\n  ?TODO\n",
        laws="""\
law r_step:
  for xs: List<Nat>
  {S.r(P.append(xs, xs)) == P.append(S.r(xs), S.r(xs)) : List<Nat>}
""",
    )
    anchors([], str(manifest))
    out = capsys.readouterr().out
    assert "[B] r: every law naming it names it on both sides: ['r_step']" in out


def test_anchors_passes_a_target_one_law_anchors_absolutely(tmp_path, capsys):
    """The repair for that shape: one law whose right-hand side does not call
    the target. Either half alone is not a recursion; the pair is."""
    manifest = _task(
        tmp_path, "t-anchored",
        stub="def r(xs: List<Nat>) -> List<Nat>:\n  ?TODO\n",
        laws="""\
law r_nil:
  {S.r(Nil{}) == Nil{} : List<Nat>}

law r_step:
  for xs: List<Nat>
  {S.r(xs <> xs) == S.r(xs) : List<Nat>}
""",
    )
    anchors([], str(manifest))
    out = capsys.readouterr().out
    assert "t-anchored" not in out
    assert "flagged tasks: 0" in out


def test_anchors_does_not_read_a_right_hand_call_as_both_sides(tmp_path, capsys):
    """The regression, caught by running the screen over the bank rather than
    by writing it: counting an occurrence on *either* side as "both sides"
    flagged `t2-chunks-laws`'s `chunks_go`, which `chunks_cons` determines from
    the right -- `S.chunks(x <> xs, 1n+n) == S.chunks_go(...)` pins `chunks_go`
    at that instantiation. A target named only on the right is anchored by that
    law, not left free by it, and the first version of this screen said
    otherwise."""
    manifest = _task(
        tmp_path, "t-rhs",
        stub="def c(xs: List<Nat>) -> Nat:\n  ?TODO\n\ndef c_go(xs: List<Nat>, x: Nat) -> Nat:\n  ?TODO\n",
        laws="""\
law c_cons:
  for x: Nat
  for xs: List<Nat>
  {S.c(x <> xs) == S.c_go(xs, x) : Nat}
""",
    )
    anchors([], str(manifest))
    out = capsys.readouterr().out
    assert "c_go" not in out
    assert "flagged tasks: 0" in out
