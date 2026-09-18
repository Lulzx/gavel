import Base
import ./prelude.bend as P

# The tests are combined with `and` rather than `or`, so an element is
# reported only when the rest of the list is also odd. The nil law holds
# -- `and` with `False{}` is `False{}` either way -- and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_odd_nil'], first
# failure at `LAWS.has_odd_snoc`.
def has_odd(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_odd_b(h), has_odd(t))
