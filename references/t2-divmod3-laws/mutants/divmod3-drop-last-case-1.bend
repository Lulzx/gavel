import Base
import ./prelude.bend as P

def divmod3(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.MkPair{0n, 0n}
    case 1n:
      P.MkPair{0n, 1n}
    case 2n:
      P.MkPair{0n, 2n}
