import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: subtracting a number from a sum it appears in on the right cancels it.
law sub_cancel:
  for x: Nat
  for y: Nat
  {S.sub(x + y, x) == y : Nat}

# LAW: nothing minus anything is zero. `sub_cancel` cannot reach the branch
# where the first argument is `0n` and the second a successor: it needs
# `a = x + y` and `b = x`, so `a = 0n` forces `x = y = 0n` and hence `b = 0n`.
# That branch is therefore unconstrained, and a body answering `1n` there
# proves `sub_cancel` at tier 4, reward 1.000. This law lands on it.
law sub_saturates:
  for y: Nat
  {S.sub(0n, y) == 0n : Nat}
