import Base
import ./prelude.bend as P

# TODO(policy): implement. `lcm_go(fuel, c, step, m)` is the walk: the multiples
# of `step` from `c` upward, with `fuel` candidates left to try. `c` is a
# multiple of `step` by construction, so it is a common multiple exactly when it
# is also a multiple of `m`, and it is the *least* one because the candidates
# are taken in order. When the budget runs out the walk answers the candidate it
# reached, which is a multiple of `step` but possibly not of `m`; the caller's
# budget is chosen so that this arm is never the answer.
#
# The test is `P.divides(c, m)`, a `Bool` term rather than a branch, because a
# `match` cannot scrutinise a computed value. `c` and `step` are each read more
# than once in the step -- `c` by the test, by the answer and by the next
# candidate, `step` by the next candidate and by the recursive call -- so both
# are declared reusable, and so is `m`, which the test and the recursive call
# both read.
def lcm_go(fuel: Nat, +c: Nat, +step: Nat, +m: Nat) -> Nat:
  ?TODO

# TODO(policy): implement. `lcm(n, m)` is the least common multiple of `n` and
# `m`:
#
#   lcm(1n, 1n)  ==  1n
#   lcm(4n, 6n)  ==  12n
#   lcm(6n, 4n)  ==  12n
#   lcm(7n, 3n)  ==  21n
#   lcm(5n, 7n)  ==  35n
#   lcm(0n, m)   ==  0n
#
# Zero is a multiple of everything and nothing is a multiple of zero, so either
# argument being `0n` answers `0n`. Otherwise the walk above is started on the
# first multiple of `n`, which is `n` itself, with `m` candidates to try: the
# multiplier that reaches the answer is `m` divided by the greatest common
# divisor of `n` and `m`, and that is at most `m`. The walk is not `gcd` --
# nothing here divides anything out.
#
# `n` and `m` are matched on and then handed to the walk, so both are declared
# reusable.
def lcm(+n: Nat, +m: Nat) -> Nat:
  ?TODO
