import Base
import ./prelude.bend as P

# A body a person would plausibly write: the cons cell answers with the tail's
# verdict alone, as if the head had already been accounted for. Rejected by
# `all_zero_snoc`: at the empty case of the induction the law's left-hand side
# is `is_zero_b(x)` for a single-element list, while this body answers `True{}`
# there.
def all_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      all_zero(t)
