import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `append` and `len`, so the policy's `drop` may lean on
# these. `append` matches on its first argument, which is what makes that law's
# left-hand side stuck for a variable `xs`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
