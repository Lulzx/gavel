import Base
import ./prelude.bend as P

def count_up(n: Nat) -> List<&2, Nat>:
  match n:
    case 1n:
      Nil{}
    case 1n++k:
      P.snoc(count_up(k), k)

def count_down(n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n++k:
      k <> count_down(k)
