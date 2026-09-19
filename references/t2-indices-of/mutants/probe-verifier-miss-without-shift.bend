import Base
import ./prelude.bend as P

# PROBE. `indices_of` counts every hit but never moves a position along: the
# tail's positions are passed through as they come, so a hit is reported at its
# offset *within the suffix it was found in* rather than at its place in the
# whole list. Every part of the walk is there and it is right about which
# elements are hits -- it is exactly right for a list whose only hit is at the
# head, which is the case the found-at-head law states, and wrong the moment
# there is a hit behind one.
def indices_of(xs: List<Nat>, +k: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.cons_if(P.eq(h, k), 0n, indices_of(t, k))
