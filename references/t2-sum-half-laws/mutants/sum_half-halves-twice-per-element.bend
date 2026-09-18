import Base
import ./prelude.bend as P

# Each element's half is counted twice: the recursive term is added once for
# the head and once more before the tail. The nil law holds; the snoc law
# refuses it, since at a variable `x` the body leaves two copies of
# `P.half(x)` where the law asks for one.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_half_nil'], first
# failure at `LAWS.sum_half_snoc`.
def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      +h2 = h
      P.half(h2) + (P.half(h2) + sum_half(t))
