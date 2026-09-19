import Base
import ./prelude.bend as P

# The walk keeps the list and measures its tail: the head of a list whose tail
# has `k` elements is the element `k` positions from the end, and a list whose
# tail is shorter than that has no such element, so it answers the default. The
# measurement is a computed value, so it is passed to `P.pick_if` rather than
# matched on in place.
def nth_from_end(xs: List<&2, Nat>, +k: Nat, +d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
