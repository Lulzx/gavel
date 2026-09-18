import Base

# Immutable, and owned by the task rather than the policy. `count_zeros` counts
# zeroes, so which numbers count as zero -- and the `append` that the law is
# stated in terms of -- are fixed here. `is_zero` is `Nat`-valued rather than
# `Bool`, so the law's right-hand side is an arithmetic term.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def is_zero(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+p:
      0n
