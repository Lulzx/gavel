import Base
import ./prelude.bend as P

# `split_at` answers a one-element first half at an empty list.
#
# This file exists for the empty-list case, which no generated mutant reaches:
# the generator rewrites a step, and `Nil{}` is an answer reached by a match
# that has already stopped. It is the reference with that case given a
# non-empty answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `split_at_nil`, `split_at_decomp`.
def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  match n:
    case 0n:
      P.MkDuo{Nil{}, xs}
    case 1n++p:
      match xs:
        case Nil{}:
          P.MkDuo{1n <> Nil{}, Nil{}}
        case h <> +t:
          P.MkDuo{h <> P.left_half(split_at(p, t)), P.right_half(split_at(p, t))}
