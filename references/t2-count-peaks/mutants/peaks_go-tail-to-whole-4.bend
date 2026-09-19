import Base
import ./prelude.bend as P

def peaks_go(t: List<&2, Nat>, prev: Nat, +h: Nat) -> Nat:
  match t:
    case Nil{}:
      0n
    case +j <> u:
      P.peak_at(prev, h, j) + peaks_go(t, h, j)

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
