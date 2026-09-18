import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `is_odd`, so the policy's `count_odd` may lean on
# both. `is_odd` is `Nat`-valued rather than `Bool`, so the law's right-hand
# side is an arithmetic term.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def is_odd(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      1n
    case 1n+1n+p:
      is_odd(p)
