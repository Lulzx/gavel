import Base
import ./prelude.bend as P

# The head's test is combined with `Bool.or` instead of `Bool.and`, so the
# answer is true as soon as one element passes -- the classic quantifier slip.
# The nil law holds; the snoc law's right-hand side conjoins the two and this
# body disjoins them.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_mult5_nil'], first
# failure at `LAWS.all_mult5_snoc`.
def all_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_mult5_b(h), all_mult5(t))
