import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and `snoc`, so the policy's `reverse` may lean on these.
# `append` matches on its first argument, which is what makes the second law's
# left-hand side work out to a reassociation of two appends.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> snoc(t, x)
