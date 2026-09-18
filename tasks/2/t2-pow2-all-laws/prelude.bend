import Base

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `pow2`, so the policy's aggregate may lean on
# both. `pow2` is `Nat`-valued rather than `Bool`, which keeps the law's
# right-hand side an arithmetic term.
# `pow2` names its argument once, so its binder is the ordinary one; the
# constant it compares or divides by is not a parameter.
def pow2(n: Nat) -> Nat:
  Nat.pow(2n, n)
