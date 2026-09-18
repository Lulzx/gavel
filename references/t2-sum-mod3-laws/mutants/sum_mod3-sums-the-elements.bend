import Base
import ./prelude.bend as P

# The reduction is dropped: the element itself is added instead of its value
# modulo three. This is the wrong-tested-value probe for the law set -- the
# snoc law's right-hand side is `P.mod3(x)` exactly, so at a variable `x` the
# body leaves `x` where the law asks for `P.mod3(x)`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_mod3_nil'], first
# failure at `LAWS.sum_mod3_snoc`.
def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_mod3(t)
