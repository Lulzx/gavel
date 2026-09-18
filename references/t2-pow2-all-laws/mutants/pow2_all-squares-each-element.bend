import Base
import ./prelude.bend as P

# Each element is squared instead of raised to the power of two -- the
# plausible slip of writing the exponent as a factor. It agrees with the
# reference only on `2n` (`2n * 2n` is `4n` and `2 ^ 2n` is `4n`); the singleton
# law refuses it at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.pow2_all_single`.
def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      Nat.mul(h2, h2) <> pow2_all(t)
