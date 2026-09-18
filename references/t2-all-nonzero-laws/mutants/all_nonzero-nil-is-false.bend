import Base
import ./prelude.bend as P

# A body a person would plausibly write: the empty list is answered with
# `False{}`, as if "every element" needed an element to be true of. Rejected by
# `all_nonzero_nil`, which is definitional: its left-hand side reduces to
# `False{}` where the law wants `True{}`. `all_nonzero_snoc` fails on this body
# too, at the empty case of its induction: there the law asks what the
# single-element list `x <> Nil{}` answers, and this body answers
# `Bool.and(P.is_nonzero_b(x), False{})`.
def all_nonzero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_nonzero_b(h), all_nonzero(t))
