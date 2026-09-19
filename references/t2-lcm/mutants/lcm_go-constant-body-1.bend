import Base
import ./prelude.bend as P

# The walk: the multiples of `step` from `c` upward, with `fuel` candidates left
# to try. `c` is a multiple of `step` by construction, so it is a common
# multiple exactly when it is also a multiple of `m`, and it is the *least* one
# because the candidates are taken in order. When the budget runs out the walk
# answers the candidate it reached, which is a multiple of `step` but possibly
# not of `m`; the caller's budget is chosen so that this arm is never the
# answer.
def lcm_go(fuel: Nat, +c: Nat, +step: Nat, +m: Nat) -> Nat:
  match fuel:
    case 0n:
      c
    case 1n++f:
      c

# The answer: the least common multiple of `n` and `m`. Zero is a multiple of
# everything and nothing is a multiple of zero, so either argument being `0n`
# answers `0n`. Otherwise the walk is started on the first multiple of `n`,
# which is `n` itself, with `m` candidates to try: the multiplier that reaches
# the answer is `m` divided by the greatest common divisor of `n` and `m`, and
# that is at most `m`.
def lcm(+n: Nat, +m: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++p:
      match m:
        case 0n:
          0n
        case 1n++q:
          lcm_go(1n + q, 1n + p, 1n + p, 1n + q)
