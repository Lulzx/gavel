import Base
import ./prelude.bend as P

def choose(n: Nat, +k: Nat) -> Nat:
  match n:
    case 0n:
      match k:
        case 0n:
          1n
        case 1n++j:
          0n
    case 1n++p:
      match k:
        case 0n:
          Nat.add(choose(p, k), choose(p, Nat.sub(k, 1n)))

        case 1n++j:
          1n
