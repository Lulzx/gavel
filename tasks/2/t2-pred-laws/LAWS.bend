import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the predecessor of a successor is the number itself.
law pred_succ:
  for x: Nat
  {S.pred(1n+x) == x : Nat}

# LAW: taking the predecessor of a sum that ends in a successor drops one.
law pred_add_succ:
  for x: Nat
  for y: Nat
  {S.pred(S.add(x, 1n+y)) == S.add(x, y) : Nat}
