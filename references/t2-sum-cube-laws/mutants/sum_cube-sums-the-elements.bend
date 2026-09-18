import Base
import ./prelude.bend as P

# The transformation is dropped: the element itself is added instead of
# the cube of that element. This is the wrong-tested-value probe for the law set -- the
# snoc law's right-hand side is `P.cube(x)` exactly, so at a variable `x` the
# body leaves `x` where the law asks for `P.cube(x)` and the two do not reduce
# alike.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_cube_nil'], first
# failure at `LAWS.sum_cube_snoc`.
def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_cube(t)
