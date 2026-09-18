import Base
import ./prelude.bend as P

# The transformation is dropped: the element itself is added instead of
# the triple of that element. This is the wrong-tested-value probe for the law set -- the
# snoc law's right-hand side is `P.triple(x)` exactly, so at a variable `x` the
# body leaves `x` where the law asks for `P.triple(x)` and the two do not reduce
# alike.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_triple_nil'], first
# failure at `LAWS.sum_triple_snoc`.
def sum_triple(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_triple(t)
