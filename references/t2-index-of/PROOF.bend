import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so
# both sides reduce to `0n` by unfolding alone.
def L.index_of_nil(k):
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides
# reduce to the same decision on `eq(h, k)` with the same two answers.
def L.index_of_step(h, k, t):
  {==}

# `eq` steps one successor off both of its arguments at once, so the step of the
# induction reduces `eq(1n+p, 1n+p)` to `eq(p, p)` and the hypothesis at `p` is
# the whole of what is left. It is a lemma of its own, under the reserved
# `Policy.*` namespace, because `eq(k, k)` is stuck where it is written.
def Policy.eq_refl(k: Nat) -> {P.eq(k, k) == True{} : Bool}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      %Policy.eq_refl(p) : {P.eq(p, p) == _ : Bool}
      {==}

# A hit at the head answers `0n`. The step unfolds to `at_if(eq(k, k), 0n, ...)`
# and `eq(k, k)` is not reducible on its own, so the comparison is settled by
# the lemma above -- which is flipped, because the goal has the term being
# rewritten on the left -- and the decision then unfolds to its first answer.
def L.index_of_hit(k, t):
  %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.at_if(_, 0n, 1n + S.index_of(t, k)) == 0n : Nat}
  {==}

# Inductive in `xs`. The head of the step is a successor, so `eq(1n+h, 0n)` is
# `False{}` by unfolding -- the inner match on `0n` is taken whatever the
# successor's predecessor is -- and the decision on it is the second answer.
# That leaves `1n + index_of(inc_all(t), 0n)` against `1n + P.len(t)`, one use
# of the hypothesis at the tail, flipped because the goal has the search on the
# left and the count on the right.
def L.index_of_miss(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, S.index_of(P.inc_all(t), 0n), P.len(t), L.index_of_miss(t)) : {1n + _ == 1n + P.len(t) : Nat}
      {==}
