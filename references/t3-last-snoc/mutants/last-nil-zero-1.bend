import Base
import ./prelude.bend as P

# The descent is the reference's, and the base case is off by one -- it answers
# `0n` instead of the default. The recursive branch is untouched, so `last_cons`
# holds, and `last_nil` is the pin that fixes the bottom of the recursion: it
# rejects `0n` against `d`. The work law's helper fails too, and for the same
# reason -- `Policy.last_snoc_general` reaches the empty list at its own base.
def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      last(t, h)
