import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append`, so the policy's `dup_all` may lean on it. `append`
# matches on its first argument, which is what makes the second law inductive.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
