import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing of nothing is nothing. Definitional -- the match on `0n` answers
# without recursing -- and it is a pin: it fixes the answer on the smallest
# input, which the step law below does not reach, since that one is stated at
# `1n + k` and only ever compares against what `sum_odd` answers at `k`.
law sum_odd_zero:
  {S.sum_odd(0n) == 0n : Nat}

# LAW: the step. One more term adds the next odd number, `k + k + 1n`, to the
# sum below it. Both sides compute, so this is definitional, and it is the law
# that says which numbers are being added up: a body that added `k + k` -- the
# even numbers -- or that added the same term twice, satisfies the pin above
# and leaves the two sides unconvertible here.
law sum_odd_succ:
  for +k: Nat
  {S.sum_odd(1n + k) == S.sum_odd(k) + (k + k + 1n) : Nat}

# LAW: the even total is empty at nothing, for the same reason as the odd one,
# and is the other pin.
law sum_even_zero:
  {S.sum_even(0n) == 0n : Nat}

# LAW: the step, with the next even number `k + k` in place of `k + k + 1n`.
# Definitional. The two step laws are what keep the two functions apart: a body
# that gave `sum_even` the odd step satisfies `sum_odd_succ` and fails here.
law sum_even_succ:
  for +k: Nat
  {S.sum_even(1n + k) == S.sum_even(k) + (k + k) : Nat}

# LAW: the odd total is the even total plus one for every term -- `1n + 3n + ...
# + (2n - 1n)` against `0n + 2n + ... + (2n - 2n)`. This is the interaction,
# and the reason the two functions are one task: on a variable `n` neither side
# computes, so the two sides are not convertible and the induction is the
# proof. The two step laws above fix each function against itself at its own
# `k` and say nothing about the two of them at the same `n`; this is the law
# that ties the two arguments together, and its step has to move an `1n` past a
# variable, which no unfolding does.
law sum_odd_sum_even:
  for +n: Nat
  {S.sum_odd(n) == S.sum_even(n) + n : Nat}
