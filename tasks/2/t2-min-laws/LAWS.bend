import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the smaller of a number and itself is that number. Alone it does not pin
# `min`: the projection `min(a, b) = a` (or `= b`) satisfies it.
law min_self:
  for x: Nat
  {S.min(x, x) == x : Nat}

# LAW: `min` does not care about the order of its arguments. Alone it does not
# pin `min` either: every constant body satisfies it. Together the two laws do
# pin it -- `min_self` kills the constants, and `min_comm` kills both
# projections, which disagree as soon as the arguments differ.
law min_comm:
  for x: Nat
  for y: Nat
  {S.min(x, y) == S.min(y, x) : Nat}
