import Base
import ./prelude.bend as P

# Any non-empty list answers `False{}`: the recursion is written and the
# answer is replaced. The nil law holds; the snoc law fails, since for the
# singleton it appends its right-hand side is P.is_one_b(x) and this body answers
# `False{}`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_one_nil'], first
# failure at `LAWS.all_one_snoc`.
def all_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      False{}
