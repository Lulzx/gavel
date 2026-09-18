import Base
import ./prelude.bend as P

# A body a person would plausibly write: the conjunction is written with the two
# tests the other way round. It is the same answer element by element, but
# `Bool.and` matches on its *first* argument, so with the tail's verdict as the
# first argument the term is stuck on a symbolic tail. Rejected by
# `all_zero_snoc`: the reference proof's induction never gets a reduction to
# work with, so the conjoined tail the law asks for is not formed.
def all_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(all_zero(t), P.is_zero_b(h))
