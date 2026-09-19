import Base
import ./prelude.bend as P

def scan_add(xs: List<Nat>, +acc: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      (acc + h) <> scan_add(t, acc + h)

    case +h <> t:
      Nil{}
