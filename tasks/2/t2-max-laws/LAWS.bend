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

# LAW: zero is the identity on the left. The two laws above pin `max` only as
# symmetric and idempotent, which is exactly the pair of properties the minimum
# has, so `max-is-min` proved both at full reward -- as did a `max` answering
# `0n` whenever either argument is. This law fixes the value on a zero argument
# rather than comparing the function with itself.
law max_zero_left:
  for y: Nat
  {S.max(0n, y) == y : Nat}

# LAW: two successors are one more than the maximum of what they wrap. With the
# zero law this pins the step, so `min` dies on `max_zero_left` rather than
# reaching full reward. Definitional for the reference.
law max_succ_succ:
  for p: Nat
  for q: Nat
  {S.max(1n+p, 1n+q) == 1n + S.max(p, q) : Nat}
