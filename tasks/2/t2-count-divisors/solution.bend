import Base
import ./prelude.bend as P

# TODO(policy): implement. `cd_go(n, k)` counts how many of `1n, ..., k` divide
# `n`: `k` is the largest divisor still to be tested, and the answer is the
# contribution of `k` -- `1n` when `k` divides `n`, `0n` otherwise -- added to
# the walk below it. The recursion consumes `k`, so `k` is a subterm at every
# step and `n` is carried along unchanged.
#
# The test is `P.divides(n, k)`, a `Bool` term rather than a `match`: a `match`
# cannot scrutinise a computed value, so the remainder cannot be the scrutinee
# of a branch. `n` and `k` are each read more than once in the step -- `n` by
# the test and by the recursive call, `k` by the test and by the recursive
# call's argument -- so both are declared reusable: `+n` and `+k`.
def cd_go(+n: Nat, +k: Nat) -> Nat:
  ?TODO

# TODO(policy): implement. `count_divisors(n)` is how many positive numbers
# divide `n`, counting `1n` and `n` themselves:
#
#   count_divisors(1n)   ==  1n
#   count_divisors(7n)   ==  2n
#   count_divisors(12n)  ==  6n
#
# `0n` has no divisors here: every positive number divides it, so the count
# would not be a number. The walk above tests `n` itself down to `1n` and stops
# at zero. `n` is read twice -- once by the walk's test and once as its starting
# point -- so it is declared reusable.
def count_divisors(+n: Nat) -> Nat:
  ?TODO
