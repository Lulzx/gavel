import Base
import ./prelude.bend as P

def gcd(fuel: Nat, a: Nat, +b: Nat) -> Nat:
  match fuel:
    case 0n:
      a
    case 1n++k:
      match b:
        case 0n:
          a
        case 1n++j:
          gcd(k, b, Nat.mod(a, b))
