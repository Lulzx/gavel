import Base
import ./prelude.bend as P

# The step answers only the head's oddness and never recurses, so the answer
# depends on the first element alone. The base case survives; the induction
# in `count_odd_snoc` does not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['count_odd_nil'], first
# failure at `LAWS.count_odd_snoc`.
def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_odd(h)
