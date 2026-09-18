import Base
import ./prelude.bend as P

# The head's *successor* is tested, so the predicate is applied to the wrong
# number -- a plausible slip when the unary encoding has to be stepped around
# a successor. The nil law holds vacuously; the snoc law fails at its own
# P.is_even_b(x).
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_even_nil'], first
# failure at `LAWS.all_even_snoc`.
def all_even(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(P.is_even_b(1n + h), all_even(t))
