import Base

# Immutable, and owned by the task rather than the policy: the content law
# below is stated in terms of `append`, `take` and `drop`, so the policy's
# `insert_at` may lean on them. Each matches on its first argument, which is
# what leaves a goal about any of them at a variable list stuck.

# `xs` followed by `ys`. It matches on its first argument.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The first `n` elements of `xs`, or all of `xs` when it is shorter. It matches
# on the *count* first and only then on the list, so `take(0n, xs)` answers
# `Nil{}` whatever `xs` is, and a successor count against a variable list does
# not reduce -- the list has to be split for the recursion to step.
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

# `xs` with its first `n` elements removed, or `Nil{}` when it is shorter. It
# matches on the count first in the same way, so `drop(0n, xs)` hands `xs`
# back outright.
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
