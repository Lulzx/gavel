import Base
import ./prelude.bend as P

# The walk answers a peak when the list runs out.
#
# The element the walk is carrying when the list runs out is the last element of
# the input, which has one neighbour and is not a peak. This is the reference
# with the walk's `Nil{}` case given a non-zero answer, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `peaks_go_nil`, `count_peaks_three`.
def peaks_go(t: List<&2, Nat>, prev: Nat, +h: Nat) -> Nat:
  match t:
    case Nil{}:
      1n
    case +j <> u:
      P.peak_at(prev, h, j) + peaks_go(u, h, j)

def count_peaks(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match t:
        case Nil{}:
          0n
        case j <> u:
          peaks_go(u, h, j)
