import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no width left means no digits read and nothing added. The left-hand side
# is a ground term in the width and both sides compute, so this is
# definitional: it fixes the answer the recursion reaches when the walk has run
# out of digits, and the step law below never reaches it, because that one is
# stated at `1n + w`.
law digit_sum_no_fuel:
  for n: Nat
  {S.digit_sum(0n, n) == 0n : Nat}

# LAW: one more unit of width reads one more digit. This is the law with the
# content, and it is what says the base is ten and the digits are read from the
# low end: the digit that comes off is `Nat.mod(n, 10n)` and what is left is
# `Nat.div(n, 10n)`. Both sides compute, because the width `1n + w` is a
# successor, so this is definitional too. A body that read base-2 digits, or
# that divided by ten without adding the digit, or that added the digit but did
# not divide, leaves the two sides unconvertible.
law digit_sum_step:
  for +w: Nat
  for +n: Nat
  {S.digit_sum(1n + w, n) == Nat.mod(n, 10n) + S.digit_sum(w, Nat.div(n, 10n)) : Nat}

# LAW: one closed value, on a number whose digits are all different: `123n` is
# `1n`, `2n` and `3n` in base ten, so three units of width read all of them and
# the answer is `6n`. Both sides are closed, so the walk computes and this is a
# check on the recurrence rather than an unfolding of it. The number stays small
# on purpose: `Nat.divmod.go` steps once per unit of the number, so the cost of
# a closed law is linear in the number itself, and a ten-digit number would not
# finish.
law digit_sum_123:
  {S.digit_sum(3n, 123n) == 6n : Nat}

# LAW: a second closed value, with the zeros in the middle of the number. Ten
# raised to the third is one digit and three zeros, so four units of width read
# a `1n` and three `0n`s. It is the closed law that separates a sum of digits
# from a count of them: a body that counted would answer `4n` here and still get
# the law above right, because `123n` has three digits and `1n + 2n + 3n` is not
# `3n` by accident.
law digit_sum_thousand:
  {S.digit_sum(4n, 1000n) == 1n : Nat}
