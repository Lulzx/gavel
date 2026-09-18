import Base
import ./prelude.bend as P

# The step adds `1n` for every element instead of `P.is_nonzero(h)`, so the
# answer is the length of the list. This is the class the law comment names:
# the nil law holds and the snoc law fails, because its right-hand side is
# `P.is_nonzero(x)` and the body leaves `1n`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_nonzero_nil'], first
# failure at `LAWS.sum_nonzero_snoc`.
def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + sum_nonzero(t)
