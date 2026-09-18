import Base
import ./prelude.bend as P

# The empty list counts one nonzero element, so every total is one too high.
# The nil law states the empty answer outright.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sum_nonzero_nil`.
def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.is_nonzero(h) + sum_nonzero(t)
