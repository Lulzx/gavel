import Base
import ./prelude.bend as P

# The head is tested and the answer negated, so this body is the negation of
# what the law asks at the head: the snoc law's right-hand side conjoins
# P.is_mult5_b(x) and this body contributes its negation.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_mult5_nil'], first
# failure at `LAWS.all_mult5_snoc`.
def all_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(Bool.not(P.is_mult5_b(h)), all_mult5(t))
