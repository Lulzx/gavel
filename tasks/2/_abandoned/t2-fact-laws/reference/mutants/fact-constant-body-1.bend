import Base
import ./prelude.bend as P

def fact(+n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n++k:
      1n
