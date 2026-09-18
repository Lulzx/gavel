import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the predecessor of a successor is the number itself.
law pred_succ:
  for x: Nat
  {S.pred(1n+x) == x : Nat}

# LAW: adding one on the right is adding one on the left. This is the law that
# pins `add`: `pred_succ` constrains only `pred`, and an `add` that returned its
# second argument would satisfy a law stated over `S.add` as easily as the real
# one.
law add_one:
  for x: Nat
  {S.add(x, 1n) == 1n+x : Nat}
