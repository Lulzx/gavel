import Base
import ./prelude.bend as P

# The empty list adds up to one instead of nothing, so every total is one
# too high. The nil law states the empty answer outright.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sum_cube_nil`.
def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.cube(h) + sum_cube(t)
