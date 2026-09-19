import Base
import ./prelude.bend as P

def partition_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.part_put(h, partition_below(n, t), P.le(h, n))
