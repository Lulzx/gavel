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

def min2(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          1n + min2(p, q)

def min_go(+t: List<&2, Nat>, +m: Nat) -> Nat:
  match t:
    case Nil{}:
      m
    case h <> t2:
      min_go(t2, min2(m, h))

def dm_dec(+h: Nat, +h2: Nat, +t2: List<&2, Nat>, r: List<&2, Nat>, k: Bool) -> List<&2, Nat>:
  match k:
    case True{}:
      h2 <> t2
    case False{}:
      h <> r

def dm_put(+h: Nat, +t: List<&2, Nat>, r: List<&2, Nat>) -> List<&2, Nat>:
  match t:
    case Nil{}:
      Nil{}
    case h2 <> t2:
      dm_dec(h, h2, t2, r, le(h, min_go(h2 <> t2, h2)))
