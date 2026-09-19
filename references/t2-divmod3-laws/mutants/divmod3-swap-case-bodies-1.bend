import Base
import ./prelude.bend as P

def divmod3(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.shift(divmod3(k))

    case 1n:
      P.MkPair{0n, 1n}
    case 2n:
      P.MkPair{0n, 2n}
    case 3n++k:
      P.MkPair{0n, 0n}
