import Base

# The reference solution: both functions step on the count first, and consult
# the list only to find out whether there is anything left to step onto.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> take(k, t)

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          Nil{}
