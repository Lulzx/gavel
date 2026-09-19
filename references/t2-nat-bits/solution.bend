import Base
import ./prelude.bend as P

def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      Nil{}
    case 1n+p:
      Nat.mod(n, 2n) <> nat_bits(p, Nat.div(n, 2n))
