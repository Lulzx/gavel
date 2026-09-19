import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the walk has nothing left to test at zero, so it contributes nothing.
# The left-hand side is ground in the argument the walk matches on and both
# sides compute, so this is definitional. It is a pin on the answer the
# recursion reaches when the count has run out -- and the walk reaches it for
# every `n`, including `0n`, so it is also the law that fixes what a number with
# no divisors counts to.
law cd_go_zero:
  for n: Nat
  {S.cd_go(n, 0n) == 0n : Nat}

# LAW: the step. `k` contributes one when it divides `n` and nothing when it
# does not, and then the walk continues below it. Both sides compute, so this is
# the definition written out, and it is the law that says *which* numbers are
# counted and in which direction the walk runs: a body that took the remainder
# the other way round, or that walked upward, or that counted `k` whether or not
# it divided, has a different unfolding here.
law cd_go_step:
  for +n: Nat
  for +k: Nat
  {S.cd_go(n, 1n + k) == Bool.pick(Nat, P.divides(n, 1n + k), 1n, 0n) + S.cd_go(n, k) : Nat}

# LAW: the hand-off from the answer to the walk. The count of the divisors of
# `n` is the walk from `n` itself down to `1n`, so the largest number tested is
# `n` and every divisor of `n` is below it or equal to it. Both sides compute,
# so this is definitional; it is the law that says where the walk starts. A body
# that started the walk at `1n` and stopped before reaching `n`, or that tested
# only up to half of `n`, is separated here.
law count_divisors_handoff:
  for +n: Nat
  {S.count_divisors(n) == S.cd_go(n, n) : Nat}

# LAW: one has one divisor, itself. The right-hand side calls no target, so this
# is an absolute anchor, and the left-hand side is ground: a body that answered
# `0n` on the last step of the walk, or that stopped the walk one short of `1n`,
# satisfies the step law above at every `k` above zero and is separated here.
law count_divisors_one:
  {S.count_divisors(1n) == 1n : Nat}

# LAW: a prime has two divisors, `1n` and itself, and `7n` is the smallest prime
# above the last one. The right-hand side calls no target, so this is an anchor
# too, and it is the closed value that separates a body whose walk tests every
# number below `n` from one that tests nothing, or that answers whether a
# *particular* number divides `n`.
law count_divisors_seven:
  {S.count_divisors(7n) == 2n : Nat}

# LAW: `12n` has six divisors -- `1n`, `2n`, `3n`, `4n`, `6n` and `12n` -- so a
# body that answered the *sum* of the divisors, or their largest one, or the
# count of the even ones, is separated here. The right-hand side calls no
# target, and both sides are numerals, so this is the closed value that fixes
# what the recurrence of the two laws above is a recurrence *of*.
law count_divisors_twelve:
  {S.count_divisors(12n) == 6n : Nat}
