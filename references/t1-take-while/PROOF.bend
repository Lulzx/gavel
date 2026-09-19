import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the body reduces on it and both sides are
# `Nil{}`.
def L.take_while_nil(n):
  {==}

# The premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
# predicate sits, so the rewrite is the premise turned round: `Equal.sym` gives
# `{True{} == P.le(h, n)}` and a step rewrites the right side of its equation
# to the left, which is what turns `P.keep_put`'s decision into a literal. Once
# it is a literal the helper steps and the two sides are the same cons cell.
def L.take_while_keep(h, t, n, e):
  %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.keep_put(h, S.take_while(t, n), _) == h <> S.take_while(t, n) : List<Nat>}
  {==}

# The same rewrite in the other direction, and the two sides collapse to
# `Nil{}` on both sides of the equation. Nothing here touches the recursion:
# the helper answers before the tail does, which is what "the walk stops" means.
def L.take_while_stop(y, t, n, e):
  %Equal.sym(Bool, P.le(y, n), False{}, e) : {P.keep_put(y, S.take_while(t, n), _) == Nil{} : List<Nat>}
  {==}
