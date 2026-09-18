import Base
import ./prelude.bend as P

# Any non-empty list answers `False{}`: the recursion is written and the
# answer is replaced. The nil law holds; the snoc law fails, since for the
# singleton it appends its right-hand side is P.is_mult5_b(x) and this body answers
# `False{}`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_mult5_nil'], first
# failure at `LAWS.all_mult5_snoc`.
def all_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      False{}
