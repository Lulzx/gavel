import Base
import ./prelude.bend as P

# The step ignores the head entirely, so every list counts zero odd elements.
# The base case is already `0n`; this is the body that forgets to add the
# head's contribution.
# Measured: `proof_tier=3 bare_tier=2`, proven ['count_odd_nil'], first
# failure at `LAWS.count_odd_snoc`.
def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      count_odd(t)
