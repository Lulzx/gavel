import Base
import ./prelude.bend as P

# TODO(policy): implement. `no_divisor(n, k)` is "none of `2n, ..., k` divides
# `n`". The walk takes `k` down one at a time and answers `True{}` once it
# reaches `1n` or `0n`, which are the two values a test of "some number at least
# two" never reaches. `k` is the argument that shrinks, so it comes second and
# `n` is carried along unchanged.
#
# The test is `P.divides(n, k)`, a `Bool` term rather than a branch, because a
# `match` cannot scrutinise a computed value. `n` is read by that test and by
# the recursive call, and `k` is read by the test and by the recursive call's
# argument, so both are declared reusable: `+n` and `+k`.
def no_divisor(+n: Nat, +k: Nat) -> Bool:
  ?TODO

# TODO(policy): implement. `is_prime(n)` is `True{}` exactly when `n` has no
# proper divisor above `1n`. `0n` and `1n` are not prime and there is no walk to
# run for them: the answer is `False{}` outright. Every other `n` is at least
# `2n`, and the largest number below it is `n - 1n`, which is what the walk
# above starts on -- `n` itself is skipped because a number always divides
# itself. `n` is matched on and then handed to the walk, so it is declared
# reusable.
def is_prime(+n: Nat) -> Bool:
  ?TODO
