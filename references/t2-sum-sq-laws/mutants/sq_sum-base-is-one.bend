import Base
import ./prelude.bend as P

# The empty list adds up to one instead of nothing, so every total is one
# too high. The nil law states the empty answer outright.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sq_sum_nil`.
def sq_sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.sq(h) + sq_sum(t)
