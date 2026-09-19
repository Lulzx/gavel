import Base
import ./prelude.bend as P

def divmod3(n: Nat) -> P.Pair:
  match n:
    case 1n:
      P.MkPair{0n, 0n}
    case 1n:
      P.MkPair{0n, 1n}
    case 2n:
      P.MkPair{0n, 2n}
    case 3n++k:
      P.shift(divmod3(k))
