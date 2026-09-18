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

# LAW: the predecessor of zero is zero. Both laws above apply `pred` to a
# successor -- `1n+x`, and `add(x, 1n)`, which reduces to one -- so the `0n`
# case is reached by neither left-hand side. A `pred` answering `1n` there
# proves both at tier 4, reward 1.000. This is the closed-value anchor.
law pred_zero:
  for x: Nat
  {S.pred(0n) == 0n : Nat}
