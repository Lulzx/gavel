import Base
import ./prelude.bend as P

# Each element is squared instead of cubed: the exponent is off by one. The
# singleton law refuses it at a variable head, where `h * h` and `P.cube(h)`
# are different terms.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.cube_all_single`.
def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      Nat.mul(h2, h2) <> cube_all(t)
