import Base
import ./prelude.bend as P

# The head is tested and the answer negated, so this body is the negation of
# what the law asks at the head: the snoc law's right-hand side conjoins
# P.is_even_b(x) and this body contributes its negation.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_even_nil'], first
# failure at `LAWS.all_even_snoc`.
def all_even(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(Bool.not(P.is_even_b(h)), all_even(t))
