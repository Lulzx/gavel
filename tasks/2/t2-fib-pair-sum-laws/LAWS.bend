import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the pair at nothing is a zero and a one. This is definitional -- the
# match on `0n` answers without recursing -- and it is a pin: it fixes the
# answer on the smallest input, which the step law below does not reach.
law fib_pair_zero:
  {S.fib_pair(0n) == P.MkPair{0n, 1n} : P.Pair}

# LAW: the step. One more advances the pair below it: the later number becomes
# the earlier one, and the two are added for the later one. Both sides compute,
# so this is definitional, and it is the law that says the answer grows the way
# a Fibonacci pair grows. A body that added the *earlier* number to itself, or
# that advanced the pair in the wrong direction, leaves the two sides
# unconvertible here.
law fib_pair_succ:
  for +k: Nat
  {S.fib_pair(1n + k) == P.advance(S.fib_pair(k)) : P.Pair}

# LAW: nothing below zero adds up to nothing. Definitional, and the pin on
# `sum_fib`'s empty case, which the step law below does not reach.
law sum_fib_zero:
  {S.sum_fib(0n) == 0n : Nat}

# LAW: the step. One more element adds the earlier half of the pair below it to
# the total below it. Definitional, and it is the law that says which numbers
# are being added up: a body that summed the *later* halves, or that carried
# the pair through as a number, satisfies `sum_fib_zero` and fails here.
law sum_fib_succ:
  for +k: Nat
  {S.sum_fib(1n + k) == P.fst(S.fib_pair(k)) + S.sum_fib(k) : Nat}

# LAW: the running total is one less than the later half of the pair -- the
# halves of all the pairs below `n` are the Fibonacci numbers below `n`, and
# their total is one short of the next one. This is the interaction and the
# reason the two functions are one task: neither side computes on a variable
# `n`, so the two sides are not convertible and the induction is the proof. It
# is also the law that ties the two functions' arguments together: the two laws
# above fix each function against itself and say nothing about the two of them
# at the same `n`.
law sum_fib_pair:
  for +n: Nat
  {S.sum_fib(n) + 1n == P.snd(S.fib_pair(n)) : Nat}
