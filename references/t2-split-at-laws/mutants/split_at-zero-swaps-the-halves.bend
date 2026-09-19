import Base
import ./prelude.bend as P

# `split_at` answers the whole list as the *first* half at a count of zero.
#
# This file exists for the count-zero case, which no generated mutant reaches:
# the generator rewrites a step, and `0n` is an answer reached by a match that
# has already stopped. It is the reference with the `0n` case given the other
# answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `split_at_zero`, `split_at_decomp`.
def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  match n:
    case 0n:
      P.MkDuo{xs, Nil{}}
    case 1n++p:
      match xs:
        case Nil{}:
          P.MkDuo{Nil{}, Nil{}}
        case h <> +t:
          P.MkDuo{h <> P.left_half(split_at(p, t)), P.right_half(split_at(p, t))}
