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

def mf_dec(+h: Nat, +m: Nat, +rest: List<&2, Nat>, k: Bool) -> List<&2, Nat>:
  match k:
    case True{}:
      h <> m <> rest
    case False{}:
      m <> (h <> rest)

def mf_put(+h: Nat, +r: List<&2, Nat>) -> List<&2, Nat>:
  match r:
    case Nil{}:
      h <> Nil{}
    case +m <> rest:
      mf_dec(h, m, rest, le(h, m))
