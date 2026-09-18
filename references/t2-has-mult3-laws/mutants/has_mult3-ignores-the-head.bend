import Base
import ./prelude.bend as P

# The step recurses on the tail and never tests the head, so the answer is
# whether some element *before* the one just added was a multiple of three. The nil law
# holds and the snoc law fails at its own `P.is_mult3_b(x)`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_mult3_nil'], first
# failure at `LAWS.has_mult3_snoc`.
def has_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      has_mult3(t)
