import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to choose out of nothing, whatever the count. It is a
# pin: it fixes the answer on the arm where the first argument has run out and
# the count has not, which no other law here reaches, and its first argument is
# the literal `0n`.
law choose_zero_left:
  for k: Nat
  {S.choose(0n, 1n + k) == 0n : Nat}

# LAW: there is exactly one way to choose nothing. It is the other pin, on the
# arm where the count has run out, and it is an induction rather than a
# computation because the first argument is a variable: `choose` cannot look at
# `n` until it is a numeral, so the two sides are not equal by definition and no
# reflexive proof reaches this law.
law choose_zero_right:
  for n: Nat
  {S.choose(n, 0n) == 1n : Nat}

# LAW: an item is either in the selection or out of it, so a pair of successors
# counts the selections that leave the first item out plus the selections that
# take it. This is Pascal's step, it is definitional, and it is the law with the
# content: the two pins above fix only the arms where one of the counts has run
# out, and this one fixes what a body has to do before either has.
law choose_step:
  for n: Nat
  for k: Nat
  {S.choose(1n + n, 1n + k)
     == Nat.add(S.choose(n, 1n + k), S.choose(n, Nat.sub(1n + k, 1n))) : Nat}

# LAW: a closed value. The three laws above fix `choose` at every shape of
# argument, and this one fixes what they all compute, at a point where both
# sides are literals and the checker evaluates them: five choose two is ten. A
# body that answered the number of selections of *any* two-item shape, or that
# read the count as the number of items, has the right recurrence and fails
# here.
law choose_five_two:
  {S.choose(5n, 2n) == 10n : Nat}
