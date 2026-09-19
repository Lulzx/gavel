import Base

def fact(n: Nat) -> Nat:
  match n:
    case 0n:
      Nat.mul(1n+p, fact(p))

    case 1n++p:
      1n

def facts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      fact(h) <> facts(t)
