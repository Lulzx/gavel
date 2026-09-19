import Base
import ./prelude.bend as P

# The walk. `k` is the largest number still to be tested, and the answer is `k`'s
# own contribution -- `1n` when it divides `n`, `0n` otherwise -- added to the
# walk below it. The recursion consumes `k`, so the argument that shrinks is a
# subterm at every step, and `n` is carried unchanged. The test is a `Bool` term
# because a `match` cannot scrutinise the remainder, which is a computed value.
def cd_go(+n: Nat, +k: Nat) -> Nat:
  match k:
    case 0n:
      0n
    case 1n+kp:
      Bool.pick(Nat, P.divides(n, k), 1n, 0n) + cd_go(n, +n)

# The answer: the count of the divisors of `n`, walked from `n` down to `1n` by
# the helper above. `0n` answers `0n`, because every positive number divides it
# and the count would not be a number.
def count_divisors(+n: Nat) -> Nat:
  cd_go(n, n)
