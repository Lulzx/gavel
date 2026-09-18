import Base
import ./prelude.bend as P

# Each element is multiplied by three instead of cubed -- the plausible slip of
# taking the exponent as a factor. It agrees with the reference only on `0n`
# and `3n`; the singleton law refuses it at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.cube_all_single`.
def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.mul(h, 3n) <> cube_all(t)
