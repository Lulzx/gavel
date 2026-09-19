import Base

def le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          le(p, q)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def rl_put(k: Bool, n: Nat) -> Nat:
  match k:
    case True{}:
      1n + n
    case False{}:
      1n

def rl_step(+x: Nat, +t: List<&2, Nat>, n: Nat) -> Nat:
  match t:
    case Nil{}:
      1n
    case +y <> t2:
      rl_put(le(x, y), n)
