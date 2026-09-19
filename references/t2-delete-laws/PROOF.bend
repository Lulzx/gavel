import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is the literal `Nil{}`, which is the first case of the match, so both
# sides reduce to `Nil{}` by unfolding alone.
def L.delete_nil(x):
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides
# reduce to the same decision on `eq(h, x)` with the same two answers.
def L.delete_step(h, x, t):
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

# A hit at the head answers the tail. The step unfolds to `at_if(eq(k, k), t,
# ...)` and `eq(k, k)` is not reducible on its own, so the comparison is settled
# by the lemma above -- which is flipped, because the goal has the term being
# rewritten on the left -- and the decision then unfolds to its first answer.
def L.delete_hit(k, t):
  %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.at_if(_, t, k <> S.delete(k, t)) == t : List<&2, Nat>}
  {==}

# Inductive in `xs`. The head of the step is a successor of the input's head, so
# `eq(1n + h, 0n)` is `False{}` by unfolding -- the inner match on `0n` is taken
# whatever the successor's predecessor is -- and the decision on it is the
# second answer. That leaves `(1n + h) <> delete(0n, inc_all(t))` against
# `(1n + h) <> P.inc_all(t)`, one use of the hypothesis at the tail.
def L.delete_miss(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.delete_miss(t) : {(1n + h) <> S.delete(0n, P.inc_all(t)) == (1n + h) <> _ : List<&2, Nat>}
      {==}
