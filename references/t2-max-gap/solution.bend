import Base
import ./prelude.bend as P

# The walk carries the element before the current window and the largest
# distance it has seen. The head is read twice -- once for the distance and once
# as the element before the next window -- so it is marked reusable, and the
# maximum is folded in as the walk goes rather than over a list of differences.
def gap_go(xs: List<&2, Nat>, prev: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      gap_go(t, h, Nat.max(P.absdiff(prev, h), best))

# The first element has nothing before it, so the walk starts there with nothing
# seen; a list with fewer than two elements never reaches the walk at all.
def max_gap(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      gap_go(t, h, 0n)
