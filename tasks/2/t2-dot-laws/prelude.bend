import Base

# Immutable, and owned by the task rather than the policy. `dot` is what the
# policy implements; `len` and `take` are here because the law that says the
# walk stops at the shorter list is stated in terms of them.

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `take(n, xs)` is the first `n` elements of `xs`, or all of `xs` when it is
# shorter than `n`. It steps on its count, so the run grows on the right and the
# recursive call is on a predecessor of `n`.
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
