import Base

# Immutable, and owned by the task rather than the policy. The law decomposes a
# list into its first `n` elements and the rest, so the `drop` half and the
# `append` that the pieces are put back together with are fixed here.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def drop(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          h <> t
        case 1n+p:
          drop(t, p)
