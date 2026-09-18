import Base
import ./prelude.bend as P

# The head is added as its own value instead of as its nonzero-ness, so the
# answer is the sum of the elements. It agrees with the reference on lists of
# `0n`s and `1n`s; the snoc law refuses it at a variable head.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_nonzero_nil'], first
# failure at `LAWS.sum_nonzero_snoc`.
def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_nonzero(t)
