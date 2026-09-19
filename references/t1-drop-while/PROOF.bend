import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the body reduces on it.
def L.drop_while_nil(n):
  {==}

# The premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
# predicate sits, so the step is the premise turned round by `Equal.sym`. With
# the decision a literal, `P.drop_put` answers with the recursion, and the goal
# is an identity. Nothing about the tail is decided here.
def L.drop_while_keep(h, t, n, e):
  %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.drop_put(h, t, S.drop_while(t, n), _) == S.drop_while(t, n) : List<&2, Nat>}
  {==}

# The same rewrite the other way. Now the helper answers with `y <> t` instead
# of the recursion, so the law's right-hand side is exactly what the left side
# becomes and the tail's answer is never consulted.
def L.drop_while_stop(y, t, n, e):
  %Equal.sym(Bool, P.le(y, n), False{}, e) : {P.drop_put(y, t, S.drop_while(t, n), _) == y <> t : List<&2, Nat>}
  {==}
