import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len` and `sq_sum`, so the policy's `sq_prefix` may lean on
# these. All three match on their first argument, which is what makes that
# law's left-hand side stuck for a variable `xs`. `sq` names its argument twice
# -- `Nat.mul(n, n)` -- so its binder is the `+` kind, which is what lets the
# callee copy it.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def sq(+n: Nat) -> Nat:
  Nat.mul(n, n)

def sq_sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sq(h) + sq_sum(t)
