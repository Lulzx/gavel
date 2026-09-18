import Base

# Wrong: the recursion step counts two elements per cons. `len_single` is the
# closed anchor that rules it out -- `len([x])` comes back `2n` -- and the
# length law sees the next one as well.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      2n + len(t)

def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> snoc(t, x)
