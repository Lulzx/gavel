import Base
import ./prelude.bend as P

# A one-element list answers a peak.
#
# The element of a one-element list has no neighbour on either side, so it is
# not a peak; the walk is never opened and the answer is `0n`. This is the
# reference with the *inner* match's empty case given a non-zero answer, which
# is the case a one-element list reaches. Nothing else moves, so it type-checks
# and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `count_peaks_single`.
def peaks_go(t: List<&2, Nat>, prev: Nat, +h: Nat) -> Nat:
  match t:
    case Nil{}:
      0n
    case +j <> u:
      P.peak_at(prev, h, j) + peaks_go(u, h, j)

def count_peaks(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match t:
        case Nil{}:
          1n
        case j <> u:
          peaks_go(u, h, j)
