import Base
import ./prelude.bend as P

def enum_from(n: Nat, +a: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
