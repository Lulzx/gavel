import Base

# Immutable, and owned by the task rather than the policy. `append` is supplied
# here rather than being asked for, so that this task's laws speak about `len`
# alone.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
