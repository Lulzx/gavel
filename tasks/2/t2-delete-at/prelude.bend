import Base

# Immutable, and owned by the task rather than the policy: the last law is
# stated in terms of `append`, `take` and `drop`, so the policy's `delete_at`
# may lean on them. Each matches on its arguments in the order written down
# here, which is what leaves a goal about one of them at a variable list stuck
# and turns that law into an induction rather than a computation.

# `xs` followed by `ys`. It matches on its first argument.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The first `n` elements of `xs`, or all of `xs` if it is shorter. It matches on
# `n` first and then on `xs`, so a literal count steps even when the list is a
# variable, and the other way round does not.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> take(p, t)

# `xs` without its first `n` elements, or `Nil{}` if it is shorter. It matches
# on `n` first too, for the same reason, and it answers its second argument
# outright at `0n`.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(p, t)
