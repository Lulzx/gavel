import Base
import ./prelude.bend as P

# The head's *successor* is tested, so the property is read off the wrong
# number: a plausible slip when the unary encoding has to be stepped around
# a successor. The nil law holds and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_odd_nil'], first
# failure at `LAWS.has_odd_snoc`.
def has_odd(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(P.is_odd_b(1n + h), has_odd(t))
