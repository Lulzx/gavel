import Base
import ./prelude.bend as P

# The zero count adds up to one instead of nothing, so every answer is one
# too high. The zero law states the empty answer outright.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sum_prefix_zero`.
def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          h + sum_prefix(k, t)
