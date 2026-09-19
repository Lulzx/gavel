import Base

# Immutable, and owned by the task rather than the policy: the length law below
# is stated in terms of `len`, so the policy's `alternate` may lean on it.
# `len` matches on its first argument, so a goal about it at a variable list
# does not reduce on its own -- the law is a fact to be proved rather than a
# computation.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
