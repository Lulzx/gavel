import Base
import ./prelude.bend as P

# The inner `Nil{}` answers the remaining count as a one-element list instead of
# the empty list. Neither older law reaches it: `drop_succ` pairs a successor
# count with a cons cell, and `drop_append_len`'s `append(xs, ys)` is never empty
# where `len(xs)` is a successor, so `drop(1n+k, Nil{})` is orphaned.
# Measured: before `drop_nil`, tier 4, reward 1.000; after, tier 3, two of three
# laws proven (0.433 by the tier-3 formula), failing at `LAWS.drop_nil` with
# `expected : [kp] / observed : []`. Submitting this file itself reads reward
# 0.000, because the harness zeroes a submission byte-identical to a mutant.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          k <> Nil{}
        case h <> t:
          drop(k, t)
