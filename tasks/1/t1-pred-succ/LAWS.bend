import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the predecessor of a successor is the original number.
law pred_succ:
  for x: Nat
  {S.pred(1n+x) == x : Nat}

# LAW: the predecessor of `x + 1`, with the successor built by `add`, is `x`.
# Inductive in `x`, and it is what keeps the pair from being satisfied by a
# `pred` that ignores its argument.
law pred_add_one:
  for x: Nat
  {S.pred(S.add(x, 1n)) == x : Nat}
