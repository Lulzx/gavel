import Base

# Immutable, and owned by the task rather than the policy: one element on the end
# of a `Nat` list, which is what the laws about appending to a row are stated
# with. It matches on its first argument, so with a variable row the goal about
# `snoc` does not reduce, which is what the interaction law below has to step
# over.
def snoc(xs: List<&2, Nat>, y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)
