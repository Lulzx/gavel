import Base
import ./prelude.bend as P

def partition_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  match xs:
    case Nil{}:
      P.part_put(h, partition_below(t, n), P.le(h, n))

    case h <> t:
      P.MkL{Nil{}, Nil{}}
