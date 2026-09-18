import Base
import ./prelude.bend as P

# A body a person would plausibly write: the cons cell answers with the tail's
# verdict alone, as if the head had already been accounted for. Rejected by
# `all_mult3_snoc`: at the empty case of the induction the law's left-hand side
# is `is_mult3_b(x)` for a single-element list, while this body answers
# `True{}` there.
def all_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      all_mult3(t)
