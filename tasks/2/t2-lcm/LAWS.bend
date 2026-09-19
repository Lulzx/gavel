import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing is a multiple of zero, and zero is a multiple of everything, so
# `0n` on the left answers `0n`. Both sides compute, so this is definitional,
# and it is an absolute anchor -- the right side calls no target. It is the
# pin on the outer match's empty arm, which no law below reaches.
law lcm_zero_left:
  for m: Nat
  {S.lcm(0n, m) == 0n : Nat}

# LAW: and the same answer from the other side. With a variable `n` the outer
# match is stuck, so this one is the induction on `n`; its step case is the
# inner match on the literal `0n`. This is the law that separates a body which
# checked only its first argument -- one that answered `lcm_go(n, n, n)` for
# `lcm(n, 0n)` would run its walk to the end of the budget and answer a
# non-zero number. The right side calls no target.
law lcm_zero_right:
  for n: Nat
  {S.lcm(n, 0n) == 0n : Nat}

# LAW: the hand-off from the answer to the walk, at two arguments that are both
# at least one. The walk starts on `n` itself -- the first multiple of `n` --
# with `m` candidates to try, and it carries `n` as the step and `m` as the
# number it is looking for a multiple of. Both sides compute, so this is
# definitional, and it is the law that says what the budget is and where the
# walk starts: a body that started the budget at `n` rather than `m`, or that
# started the walk on `n + n`, is separated here.
law lcm_handoff:
  for +n: Nat
  for +m: Nat
  {S.lcm(1n + n, 1n + m) == S.lcm_go(1n + m, 1n + n, 1n + n, 1n + m) : Nat}

# LAW: no budget left answers the candidate reached. The left-hand side is
# ground in the argument the walk matches on and both sides are the same
# variable, so this is definitional. It is the pin on the walk's stopped answer,
# which no other law here reaches -- every other law about the walk hands it a
# budget or a candidate that is already a common multiple.
law lcm_go_no_fuel:
  for c: Nat
  for step: Nat
  for m: Nat
  {S.lcm_go(0n, c, step, m) == c : Nat}

# LAW: the step. A candidate is the answer when it is a multiple of `m` as well
# as of `step`, and otherwise the walk continues on the next multiple of
# `step`. Both sides compute, so this is definitional, and it is the law with
# the content: a body that tested the divisibility the other way round, or that
# advanced by `m` instead of by `step`, or that advanced by one, has a different
# unfolding here. It is also the law that says the candidates are taken in
# order -- the natural way to state "least" without a separate order law.
law lcm_go_step:
  for f: Nat
  for +c: Nat
  for +step: Nat
  for +m: Nat
  {S.lcm_go(1n + f, c, step, m) == Bool.pick(Nat, P.divides(c, m), c, S.lcm_go(f, c + step, step, m)) : Nat}

# LAW: the smallest case with a walk of its own length: one and one is one.
# Both sides are numerals and the right side calls no target, so this is an
# absolute anchor. A body that answered `0n` at its stopped arm fails the closed
# laws above one by one, and this is the first of them.
law lcm_one_one:
  {S.lcm(1n, 1n) == 1n : Nat}

# LAW: four and six answer twelve. The multiplier that gets there is three --
# `4n`, `8n`, `12n` -- and the budget is `6n`, so the walk stops on a candidate
# that *is* a common multiple rather than on the budget. Both sides are numerals
# and the right side calls no target, so this is an absolute anchor.
law lcm_four_six:
  {S.lcm(4n, 6n) == 12n : Nat}

# LAW: and the arguments the other way round answer the same number. The walk
# now takes two steps -- `6n`, `12n` -- where the law above took three, so this
# is the closed value that says the answer is the least *common* multiple and
# not a function of which argument came first. Both sides are numerals and the
# right side calls no target.
law lcm_six_four:
  {S.lcm(6n, 4n) == 12n : Nat}

# LAW: seven and three answer twenty-one. The two share no divisor, so the
# multiplier is `3n` and the walk stops on its third candidate; the answer is
# not the product of the two arguments *as a rule* -- `lcm_four_six` is `12n`
# where the product is `24n` -- and this is the closed value that says the walk
# finds the multiple rather than the product. Both sides are numerals.
law lcm_seven_three:
  {S.lcm(7n, 3n) == 21n : Nat}

# LAW: five and seven answer thirty-five, and this is the law that pins the
# *budget*. The walk reaches `35n` on its seventh candidate, which is exactly
# the budget `7n`; a body whose budget was the other argument -- `lcm_go(n, n,
# n, m)` started with `n` candidates -- answers `25n` here, and `lcm_four_six`
# and `lcm_six_four` do not see that, because there the multiplier is smaller
# than both arguments. Both sides are numerals and the right side calls no
# target.
law lcm_five_seven:
  {S.lcm(5n, 7n) == 35n : Nat}
