import Base
import ./prelude.bend as P

def take_last(xs: List<&2, Nat>, +k: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
