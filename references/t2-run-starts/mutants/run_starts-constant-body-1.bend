import Base
import ./prelude.bend as P

# The walk: nothing left to open at the empty list. A cons cell hands its head's
# comparison with the element before it to `P.put_start` together with the
# position, and recurses on the tail one position along, with the head as the
# element before it.
def run_starts_go(rest: List<&2, Nat>, prev: Nat, +i: Nat) -> List<&2, Nat>:
  match rest:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.put_start(i, run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev))

# The answer: a non-empty list opens a run at `0n`, and the tail is walked from
# `1n` with the first element as the one before it.
def run_starts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nil{}
