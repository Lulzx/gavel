import Base
import ./prelude.bend as P

# A person writing an `or`-fold can leave the recursive call out and test the
# head alone: the empty list is still answered `False{}`, so the body looks
# right at the base. Rejected by `has_mult5_snoc`, at the cons step of the
# induction: the law's left-hand side reduces to `is_mult5_b(h)` and its
# right-hand side is `or(is_mult5_b(h), is_mult5_b(x))`, and no rewrite makes
# one term of the two. `has_mult5_nil` holds of this body -- `False{}` is what
# the law wants there -- so the law that reaches the cons cells is the one that
# rejects it.
def has_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      P.is_mult5_b(h)
