import Base

# Wrong: `len` answers `1n` for the empty list. `len_single` is the closed
# anchor that rules it out -- `len([x])` comes back `2n` where the law says 1.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      1n + len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
