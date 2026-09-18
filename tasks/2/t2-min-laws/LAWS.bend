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

# LAW: zero on the left is the answer. The two laws above are both relative --
# `min_self` compares `min` with itself at the same argument and `min_comm`
# swaps the arguments -- and a transformation that preserves both is invisible
# to them. `max` preserves both exactly: it is idempotent and commutative too,
# so `min` implemented as `max` proved the whole set at **tier 4, reward
# 1.000**. This law fixes a closed value and sees the difference, since
# `max(0n, y)` is `y`.
law min_zero_left:
  for y: Nat
  {S.min(0n, y) == 0n : Nat}

# LAW: and the step, which pins the rest. `min` of two successors is the
# successor of the `min` of the predecessors; `max` satisfies the same equation
# with `max` on the right, so this is the second half of the anchor rather than
# a restatement of the first.
law min_succ_succ:
  for p: Nat
  for q: Nat
  {S.min(1n+p, 1n+q) == 1n + S.min(p, q) : Nat}
