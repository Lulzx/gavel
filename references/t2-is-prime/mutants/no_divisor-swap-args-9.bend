import Base
import ./prelude.bend as P

# `no_divisor(n, k)` is "none of `2n, ..., k` divides `n`". The walk takes `k`
# down one at a time and answers `True{}` once it reaches `1n` or `0n`, which are
# the two values a test of "some number at least two" never reaches. `k` is the
# argument that shrinks, so it comes second and `n` is carried unchanged.
#
# The test is `P.divides(n, k)`, a `Bool` term rather than a branch, because a
# `match` cannot scrutinise a computed value.
def no_divisor(+n: Nat, +k: Nat) -> Bool:
  match k:
    case 0n:
      True{}
    case 1n+kp:
      match kp:
        case 0n:
          True{}
        case 1n+j:
          Bool.and(Bool.not(P.divides(k, n)), no_divisor(n, kp))

# The answer. `0n` and `1n` are not prime, and there is no walk to run for them:
# the answer is `False{}` outright. Every other `n` is at least `2n`, and the
# largest number below it is `n - 1n`, which is what the walk starts on -- `n`
# itself is skipped because a number always divides itself.
def is_prime(+n: Nat) -> Bool:
  match n:
    case 0n:
      False{}
    case 1n+p:
      match p:
        case 0n:
          False{}
        case 1n+q:
          no_divisor(n, 1n + q)
