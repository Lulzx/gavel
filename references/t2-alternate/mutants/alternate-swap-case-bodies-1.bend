import Base
import ./prelude.bend as P

def alternate(n: Nat, +a: Nat, +b: Nat) -> List<Nat>:
  match n:
    case 0n:
      a <> alternate(p, b, a)

    case 1n+p:
      Nil{}
