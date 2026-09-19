import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is the literal `Nil{}`, which is the first case of the match, so both
# sides reduce to `Nil{}` by unfolding alone.
def L.positions_nil(x):
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides
# reduce to the same decision on `eq(h, x)` with the same two answers.
def L.positions_step(h, x, t):
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

# A hit at the head records `0n`. The step unfolds to `at_if(eq(k, k), 0n <> ...,
# ...)` and `eq(k, k)` is not reducible on its own, so the comparison is settled
# by the lemma above -- which is flipped, because the goal has the term being
# rewritten on the left -- and the decision then unfolds to its first answer.
def L.positions_hit(k, t):
  %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.at_if(_, 0n <> P.inc_all(S.positions(k, t)), P.inc_all(S.positions(k, t))) == 0n <> P.inc_all(S.positions(k, t)) : List<&2, Nat>}
  {==}

# Inductive in `xs`. The head of the step is a successor of the input's head, so
# `eq(1n + h, 0n)` is `False{}` by unfolding -- the inner match on `0n` is taken
# whatever the successor's predecessor is -- and the decision on it is the
# second answer. That leaves `inc_all(positions(0n, inc_all(t)))` against
# `Nil{}`, one use of the hypothesis at the tail inside the shift.
def L.positions_miss(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, S.positions(0n, P.inc_all(t)), Nil{}, L.positions_miss(t)) : {P.inc_all(_) == Nil{} : List<&2, Nat>}
      {==}
