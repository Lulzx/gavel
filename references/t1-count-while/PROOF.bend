import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the body reduces on it.
def L.count_while_nil(n):
  {==}

# The premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
# predicate sits, so the step is the premise turned round by `Equal.sym` -- a
# step `%e : P` replaces the right side of `e`'s equation by the left in the
# motive `P`. With the decision a literal, `P.count_put` answers `1n + c` and
# the two sides of the law are the same term.
def L.count_while_keep(h, t, n, e):
  %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.count_put(S.count_while(t, n), _) == 1n + S.count_while(t, n) : Nat}
  {==}

# The same rewrite with the other literal. The helper answers `0n` without
# looking at the recursion at all, which is exactly what the law claims.
def L.count_while_stop(y, t, n, e):
  %Equal.sym(Bool, P.le(y, n), False{}, e) : {P.count_put(S.count_while(t, n), _) == 0n : Nat}
  {==}
