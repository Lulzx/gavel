import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `sq`, so the policy's `sq_all` may lean on both.
# `sq` names its argument twice -- `Nat.mul(n, n)` -- so its binder is the `+`
# kind, which is what lets the callee copy it.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sq(+n: Nat) -> Nat:
  Nat.mul(n, n)
