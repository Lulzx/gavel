import Base
import ./prelude.bend as P

# `ext_go` answers a one-element list on an empty tail.
#
# This file exists for a law that no generated mutant fails: `ext_go_nil`'s
# left-hand side is `ext_go(Nil{}, lo, hi)`, so the match has already stopped
# and the two running values are the answer rather than something a step
# produces. It is the reference with that one case given a shorter answer, so it
# type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `ext_go_nil`, `ext_go_len`, `extremes_single`.
def ext_go(xs: List<&2, Nat>, lo: Nat, hi: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      lo <> Nil{}
    case +h <> t:
      ext_go(t, P.min2(h, lo), P.max2(h, hi))

def extremes(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      ext_go(t, h, h)
