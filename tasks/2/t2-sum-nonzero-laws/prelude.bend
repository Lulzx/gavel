import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `is_nonzero`, so the policy's `sum_nonzero` may
# lean on both. `is_nonzero` is `Nat`-valued rather than `Bool`, so the law's
# right-hand side is an arithmetic term.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def is_nonzero(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      1n
