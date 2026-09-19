import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The loop started at
# the input itself rather than at the pointer `lookahead` computes: every
# non-empty suffix is walked, so a window is emitted at each one and the last
# `k - 1` windows of the answer are too short. It is the plausible way to write
# the loop if the pointer is read as "how far along the input we are" rather
# than "how many windows are left".

def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      P.take(xs, k) <> windows_go(t, k, P.tail(xs))

def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match k:
    case 0n:
      Nil{}
    case 1n+p:
      windows_go(xs, k, xs)
