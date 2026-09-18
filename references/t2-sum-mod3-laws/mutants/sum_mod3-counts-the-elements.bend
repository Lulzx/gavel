import Base
import ./prelude.bend as P

# The step adds `1n` per element instead of the reduced value, so the answer is
# the length of the list. The nil law holds; the snoc law fails at a variable
# element.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_mod3_nil'], first
# failure at `LAWS.sum_mod3_snoc`.
def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + sum_mod3(t)
