import Base
import ./prelude.bend as P

def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      x <> replicate(k, x)

    case 1n+k:
      Nil{}
