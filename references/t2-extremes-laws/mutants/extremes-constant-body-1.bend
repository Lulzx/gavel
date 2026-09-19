import Base
import ./prelude.bend as P

def ext_go(xs: List<&2, Nat>, lo: Nat, hi: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      lo <> hi <> Nil{}
    case +h <> t:
      ext_go(t, P.min2(h, lo), P.max2(h, hi))

def extremes(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      Nil{}
