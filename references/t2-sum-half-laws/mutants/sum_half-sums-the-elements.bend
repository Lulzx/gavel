import Base
import ./prelude.bend as P

# The halving is dropped: the element itself is added instead of its half. This
# is the wrong-tested-value probe for the law set -- the snoc law's right-hand
# side is `P.half(x)` exactly, which at a variable `x` never meets the `x` the
# body leaves.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_half_nil'], first
# failure at `LAWS.sum_half_snoc`.
def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_half(t)
