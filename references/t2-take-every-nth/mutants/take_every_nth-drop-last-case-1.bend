import Base
import ./prelude.bend as P

# The walk. `xs` is what is left to read -- it comes first because the checker
# reads a recursive call's arguments left to right and asks that each be passed
# unchanged until one shrinks -- `m` is the number of elements to skip between
# two kept ones, and `i` is the number of skips still owed. Nothing owed means
# the element in hand is kept and the next gap starts at `m`; anything owed means
# it is passed over and the debt goes down by one. `m` is read twice on the
# keeping step -- once as the count just paid off and once as the count the next
# gap starts from -- so it is declared reusable, and the tail is read once on
# each side of the inner match, so it is declared reusable too.
def every_nth_go(xs: List<&2, Nat>, +m: Nat, i: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> +t:
      match i:
        case 0n:
          h <> every_nth_go(t, m, m)
        case 1n+q:
          every_nth_go(t, m, q)

# The answer. A stride of `0n` names no position, so nothing is kept. A positive
# stride is one plus the number of elements to skip, and the walk opens on the
# whole list with nothing owed -- which is what makes the first element one of
# the kept ones, `0n` being the first position it is at.
def take_every_nth(n: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
