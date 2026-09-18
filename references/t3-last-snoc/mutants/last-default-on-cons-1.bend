import Base
import ./prelude.bend as P

# Returns the default for every nonempty list, so it never descends at all. It
# is the weakest of the near misses and it still type-checks, which is the point:
# the base case is the reference's, so `last_nil` holds, and `last_cons` is the
# pin that rejects it -- the left side computes to `d` and the law's right side
# is `S.last(t, h)`, which does not reduce to `d` for a variable tail. The work
# law's helper fails against it as well.
def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case h <> t:
      d
