import Base
import ./prelude.bend as P

# Descends correctly but never updates the default: the head is dropped instead
# of becoming the new default, so the answer is whatever the empty list would
# have answered. It is the failure of the one thing `last` has to remember.
# `last_nil` holds -- the base case is untouched -- and `last_cons` is what
# rejects it, wanting `S.last(t, h)` where this answers `S.last(t, d)`.
def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case h <> t:
      last(t, d)
