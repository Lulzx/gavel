import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len` and `sum`, so the policy's `sum_prefix` may lean on
# these. Both match on their first argument, which is what makes that law's
# left-hand side stuck for a variable `xs`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)
