import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the larger of a number and itself is that number. Alone it does not pin
# `max`: the projection `max(a, b) = a` (or `= b`) satisfies it.
law max_self:
  for x: Nat
  {S.max(x, x) == x : Nat}

# LAW: `max` does not care about the order of its arguments. Alone it does not
# pin `max` either: every constant body satisfies it. Together the two laws do
# pin it -- `max_self` kills the constants, and `max_comm` kills both
# projections, which disagree as soon as the arguments differ.
law max_comm:
  for x: Nat
  for y: Nat
  {S.max(x, y) == S.max(y, x) : Nat}
