import Base
import ./prelude.bend as P

# The head's test is combined with `Bool.or` instead of `Bool.and`, so the
# answer is true as soon as one element passes -- the classic quantifier slip.
# The nil law holds; the snoc law's right-hand side conjoins the two and this
# body disjoins them.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_one_nil'], first
# failure at `LAWS.all_one_snoc`.
def all_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_one_b(h), all_one(t))
