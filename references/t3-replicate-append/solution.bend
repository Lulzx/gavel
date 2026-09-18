import Base

def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> replicate(k, x)
