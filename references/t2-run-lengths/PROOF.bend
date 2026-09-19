import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `same` steps one successor off each side at once, so `same(a, a)` is stuck on a
# variable `a`: the reflexivity of the comparison is not an unfolding but an
# induction on `a`, and it is what the walk's law about an equal neighbour needs.
# The statement is oriented with `True{}` on the left because a rewrite step
# replaces the side that the hole in the pattern stands for.
def Policy.same_refl(a: Nat) -> {True{} == P.same(a, a) : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.same_refl(p) : {True{} == _ : Bool}
      {==}

# The input is the literal `Nil{}`, which is the answer's first case.
def L.run_lengths_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is the literal `Nil{}`, so the outer
# match takes its cons case and the inner one its empty case: both sides are the
# run `1n` in front of an empty answer.
def L.run_lengths_single(x):
  {==}

# Both sides reduce to the walk started at `1n` on the second element with the
# comparison of the two heads already decided.
def L.run_lengths_step(h, h2, t2):
  {==}

# The tail is the literal `Nil{}` and the flag is `True{}`, so the walk takes its
# first branch and then its empty tail: both sides are the run grown by the
# element in hand.
def L.run_lengths_go_last_in_run(cur, h):
  {==}

# The same, with the flag `False{}`: the run carried is emitted and the element
# in hand starts a run of one.
def L.run_lengths_go_last_alone(cur, h):
  {==}

# The flag is `True{}` and the tail is a cons cell, so both sides reduce to the
# walk one element along, with the run grown by one and the next comparison
# decided from the two elements in hand.
def L.run_lengths_go_grow(cur, h, h2, t2):
  {==}

# The flag is `False{}` and the tail is a cons cell: the run carried is emitted
# in front of the walk one element along, which starts at `1n` again.
def L.run_lengths_go_fresh(cur, h, h2, t2):
  {==}

# The walk leaves the comparison of the element in hand with itself in front of
# the walk one element along, and the law's right-hand side has `True{}` there.
# The reflexivity lemma collapses the comparison and what is left is an identity.
def L.run_lengths_go_same(cur, a, t):
  %Policy.same_refl(a) : {S.run_lengths_go(t, _, 1n + cur, a) == S.run_lengths_go(t, True{}, 1n + cur, a) : List<&2, Nat>}
  {==}

# Both sides are closed, so every match reduces: the first two elements are equal
# and the third is not, and what is left is `2n <> 1n <> Nil{}` against itself.
def L.run_lengths_three():
  {==}
