import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `same` steps one successor off each side at once, so `same(a, a)` is stuck on a
# variable `a` and the reflexivity of the comparison is not definitional: it is
# an induction on `a`, which is what `run_starts_go_same` needs. The statement is
# oriented with `True{}` on the left because a rewrite step replaces the side
# that the hole in the pattern stands for.
def Policy.same_refl(a: Nat) -> {True{} == P.same(a, a) : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.same_refl(p) : {True{} == _ : Bool}
      {==}

# The input is the literal `Nil{}`, which is the second function's first case.
def L.run_starts_nil():
  {==}

# `x <> Nil{}` is a cons cell, so the outer match takes its cons case and both
# sides are the position `0n` in front of an empty walk.
def L.run_starts_single(x):
  {==}

# The walk's empty case answers nothing, whatever it was carrying.
def L.run_starts_go_nil(prev, i):
  {==}

# The outer match takes the cons case, so both sides reduce to a `put_start` on
# the same decision, the same recursive call and the same position.
def L.run_starts_go_cons(h, t, prev, i):
  {==}

# The step leaves `put_start(i, run_starts_go(t, a, i + 1n), same(a, a))` against
# `run_starts_go(t, a, i + 1n)`. The reflexivity lemma rewrites the decision to
# `True{}`, `put_start` then takes its first answer, and what is left is an
# identity.
def L.run_starts_go_same(t, a, i):
  %Policy.same_refl(a) : {P.put_start(i, S.run_starts_go(t, a, Nat.add(i, 1n)), _) == S.run_starts_go(t, a, Nat.add(i, 1n)) : List<&2, Nat>}
  {==}

# Both sides are closed, so both matches reduce: the list opens a run at `0n`,
# the walk passes `1n` over because the element repeats the one before it, and
# opens `2n`. What is left is `0n <> 2n <> Nil{}` against itself.
def L.run_starts_three():
  {==}
