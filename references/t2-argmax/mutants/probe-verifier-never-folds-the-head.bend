import Base
import ./prelude.bend as P

# PROBE. `argmax` decides the position against the largest element seen so far,
# but never lets the head become the largest element seen so far: the walk
# recurses with `cur` exactly as it was handed in, so every later element is
# compared with the *first* element of the suffix rather than with the largest
# one. It is a whole walk and it is right about the position of a new largest
# whenever that largest is the head -- it is wrong the moment the largest is
# behind an element that already beat it, which is the case the closed-list laws
# reach and a step law at variables does not.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      bi
    case +h <> t:
      argmax_go(t, cur, P.pick_if(P.gt(h, cur), i, bi), 1n + i)

def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      argmax_go(t, h, 0n, 1n)
