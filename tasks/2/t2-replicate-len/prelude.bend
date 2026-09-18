import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len`, so the policy's `replicate` may lean on this one.
# It matches on its first argument, which is what makes that law's left-hand
# side stuck for a variable `n`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
