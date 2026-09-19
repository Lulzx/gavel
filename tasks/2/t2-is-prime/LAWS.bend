import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the walk has nothing to test at zero. The left side is ground in the
# argument the walk matches on and both sides are values, so this is
# definitional. It is a pin on the walk's stopped answer, and it is *only* about
# the stop: it says a bound below `2n` constrains nothing, which is what makes
# the walk safe to run down past the numbers that divide `n` trivially.
law no_divisor_zero:
  for n: Nat
  {S.no_divisor(n, 0n) == True{} : Bool}

# LAW: the same stop, one number higher. `1n` divides everything, so it is not
# evidence against primality and the walk must not treat it as such. Stated at
# `1n` rather than `0n` because the walk reaches the two stops by different
# arms: this is the law that separates a body which tests `1n` from one which
# skips it, and no other law here looks at that arm.
law no_divisor_one:
  for n: Nat
  {S.no_divisor(n, 1n) == True{} : Bool}

# LAW: the step. `k` is tested -- when it divides `n` the walk answers `False{}`
# at once, and when it does not the walk continues below it -- and it is stated
# at `2n + j`, the smallest `k` that the walk is obliged to test. Both sides
# unfold the same way, so this is definitional, and it is the law that says
# *which* numbers are tested and against what: a body that tested a divisor
# other than the candidates, or that carried the wrong number forward, has a
# different unfolding here. `1n + j` on the right is `k`'s predecessor, so this
# also pins that the walk descends by one and does not skip.
law no_divisor_step:
  for +n: Nat
  for +j: Nat
  {S.no_divisor(n, 2n + j) == Bool.and(Bool.not(P.divides(n, 2n + j)), S.no_divisor(n, 1n + j)) : Bool}

# LAW: the hand-off from the answer to the walk. At `2n + n` -- an `n` that is
# at least two, written so the argument is visible -- the answer is the walk
# started at `n - 1n`, not at `n` and not at a fixed bound. Both sides compute,
# so this is definitional; a body that started the walk at `n` itself, or that
# started it at `1n` and climbed, is separated here. The `2n + n` form is what
# makes the law reach the non-trivial arm: written at a bare `n` the left side
# is stuck on the match, and the law would say nothing.
law is_prime_handoff:
  for +n: Nat
  {S.is_prime(2n + n) == S.no_divisor(2n + n, 1n + n) : Bool}

# LAW: zero is not prime. Nothing below `2n` is prime, and the two closed laws
# `is_prime_zero` and `is_prime_one` are what fix that: a body whose gate is
# missing, or which lets the walk decide, answers `True{}` at one of them. The
# right side calls no target, so this is an absolute anchor.
law is_prime_zero:
  {S.is_prime(0n) == False{} : Bool}

# LAW: one is not prime, for the same reason and by a different arm -- the walk
# started at `0n` would answer `True{}` here, since nothing at or below `1n` is
# ever evidence. The right side calls no target, so this is an anchor too.
law is_prime_one:
  {S.is_prime(1n) == False{} : Bool}

# LAW: two is prime. This is the smallest `n` the walk runs for, and the walk
# has no candidates at all: `2n - 1n` is `1n`, which is the stop. So it pins
# that the walk is not started below `1n` and that the gate opens at `2n` and
# not higher. A body that answered `False{}` at the bottom of the walk, or that
# gated on `n < 3n`, is separated here.
law is_prime_two:
  {S.is_prime(2n) == True{} : Bool}

# LAW: four is not prime, and this is the smallest composite. Its only proper
# divisor above `1n` is `2n`, so it is the closed value that pins the *bottom*
# of the walk: a body that stopped testing at `3n`, or that skipped the numbers
# below some bound, answers `True{}` here, and no other law in this set reaches
# that arm -- at `7n` and `9n` such a body still answers `True{}` and `False{}`
# correctly.
law is_prime_four:
  {S.is_prime(4n) == False{} : Bool}

# LAW: seven is prime, so every candidate from `6n` down to `2n` fails to divide
# it and the walk runs all the way out. It is the anchor that separates a body
# answering `False{}` whenever a candidate exists from one answering whether a
# divisor exists -- the mistake that makes every number above `3n` composite.
law is_prime_seven:
  {S.is_prime(7n) == True{} : Bool}

# LAW: nine is not prime, and its proper divisor is `3n` -- odd, so a body that
# tested only the even candidates answers `True{}` here. Together with
# `is_prime_four` it closes the parity gap: `4n` catches a body that skips `2n`
# and `9n` catches a body that skips `3n`. Both are needed; neither substitutes
# for the other.
law is_prime_nine:
  {S.is_prime(9n) == False{} : Bool}
