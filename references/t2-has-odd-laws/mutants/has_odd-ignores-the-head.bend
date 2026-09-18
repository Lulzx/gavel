import Base
import ./prelude.bend as P

# The step recurses on the tail and never tests the head, so the answer is
# whether some element *before* the one just added was odd. The nil law
# holds and the snoc law fails at its own `P.is_odd_b(x)`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_odd_nil'], first
# failure at `LAWS.has_odd_snoc`.
def has_odd(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      has_odd(t)
