import Base

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `triple`, so the policy's aggregate may lean on
# both. `triple` is `Nat`-valued rather than `Bool`, which keeps the law's
# right-hand side an arithmetic term.
# `triple` names its argument more than once, so its binder is the `+` kind,
# which is what lets the callee copy it.
def triple(+n: Nat) -> Nat:
  n + n + n
