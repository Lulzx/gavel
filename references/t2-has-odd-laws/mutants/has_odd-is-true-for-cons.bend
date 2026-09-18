import Base
import ./prelude.bend as P

# Every nonempty list is answered `True{}`, so the elements are never looked
# at. The nil law holds; the snoc law fails, because at a variable `x` the
# right-hand side is `P.is_odd_b(x)` and the left is `True{}`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['has_odd_nil'], first
# failure at `LAWS.has_odd_snoc`.
def has_odd(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      True{}
