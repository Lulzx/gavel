import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `append`, so the policy's `sum_acc` may lean on this one.
# It matches on its first argument, which is what makes the law's left-hand
# side stuck for a variable `xs`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
