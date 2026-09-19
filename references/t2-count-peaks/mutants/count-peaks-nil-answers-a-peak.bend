import Base
import ./prelude.bend as P

# The empty list answers a peak.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and `count_peaks`'s `Nil{}` case is an answer
# reached by a match that has already stopped. It is the reference with that one
# case given a non-zero answer, so it type-checks and every recursive step is
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `count_peaks_nil`.
def peaks_go(t: List<&2, Nat>, prev: Nat, +h: Nat) -> Nat:
  match t:
    case Nil{}:
      0n
    case +j <> u:
      P.peak_at(prev, h, j) + peaks_go(u, h, j)

def count_peaks(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      match t:
        case Nil{}:
          0n
        case j <> u:
          peaks_go(u, h, j)
