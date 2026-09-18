import Base
import ./prelude.bend as P

# The tests are combined with `and` rather than `or`, so an element is
# reported only when the rest of the list is also a multiple of three. The nil law holds
# -- `and` with `False{}` is `False{}` either way -- and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_mult3_nil'], first
# failure at `LAWS.has_mult3_snoc`.
def has_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_mult3_b(h), has_mult3(t))
