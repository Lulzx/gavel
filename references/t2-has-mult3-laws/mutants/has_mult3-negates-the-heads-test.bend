import Base
import ./prelude.bend as P

# The head is tested for the wrong property: the test is negated, so an
# element counts exactly when it is *not* a multiple of three. The nil law holds and the
# snoc law fails at a variable head.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_mult3_nil'], first
# failure at `LAWS.has_mult3_snoc`.
def has_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(Bool.not(P.is_mult3_b(h)), has_mult3(t))
