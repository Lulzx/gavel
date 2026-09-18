import Base

# Immutable, and owned by the task rather than the policy: the law is stated in
# terms of `append`, so the policy's `reverse` may lean on this one. It matches
# on its first argument, which is what makes the law's left-hand side stuck.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
