import Base
import ./prelude.bend as P
import ./solution.bend as S

# There is no prelude helper to reach through, so nothing here is `P.`. The two
# laws that induct over a number bind it `+`: each names its number more than
# once -- once as the argument of the `Nat.double` call the law quantifies and
# once in the goal that is left -- and a `Nat` binder that is live twice is not
# Lone. The two ground laws have no binders at all.

# LAW: half of nothing is nothing. The left-hand side is a ground term and both
# sides compute, so this is definitional: it fixes the answer the recursion
# reaches when there is nothing left to halve, and a body that answered a unit
# there would satisfy every law below it. An empty case is an answer a stopped
# match gives rather than a step, so nothing else in this file looks at it.
law half_zero:
  {S.half(0n) == 0n : Nat}

# LAW: half of one is nothing. It is the companion of the law above and not
# implied by it: `1n` is the other answer the match gives without recursing, and
# it is the case a body that rounded *up* on the way down would get wrong while
# every recursive step below still agreed. It is the reason `half` rounds down
# rather than to nearest.
law half_one:
  {S.half(1n) == 0n : Nat}

# LAW: the step of the recursion. Both sides compute, so this is definitional,
# and it is what says the walk goes two at a time: a body that dropped one unit
# per call, or that added nothing, leaves the two sides unconvertible.
law half_step:
  for +n: Nat
  {S.half(1n + (1n + n)) == 1n + S.half(n) : Nat}

# LAW: halving undoes doubling. This is the work, and it is the law that pins
# the *value* of the answer at every even number: `Nat.double` steps two at a
# time the way `half` does, so the successor case of the induction hands `half`
# an argument one pair further along, and the hypothesis at the previous number
# is the only thing that can rewrite it. It is not a crossing of `Nat.div`:
# nothing is divided, `Nat.double` is unfolded, and the arithmetic that is left
# after the rewrite is `1n + p` on both sides. It is absolute - every number has
# a half, and this says what it is on the numbers that are twice another.
law half_double:
  for +n: Nat
  {S.half(Nat.double(n)) == n : Nat}

# LAW: halving undoes doubling with a unit on the end. It is the odd companion
# of the law above and not a consequence of it: the two together cover every
# number, and this is the one that fixes what the match's `1n` answer is worth
# at every larger odd number. A body that rounded the odds up -- the nearest
# answer rather than the floor -- satisfies the law above and fails this one.
law half_double_succ:
  for +n: Nat
  {S.half(1n + Nat.double(n)) == n : Nat}
