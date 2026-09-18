import Base
import ./prelude.bend as P

# The step adds `1n` per element instead of the element's half, so the answer
# is the length of the list. The nil law holds and the snoc law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_half_nil'], first
# failure at `LAWS.sum_half_snoc`.
def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + sum_half(t)
