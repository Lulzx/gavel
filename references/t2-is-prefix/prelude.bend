import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `eq` and of `append`, so the policy's `is_prefix` may lean on
# them. Both match on their first argument, which is what leaves a goal about
# either one at a variable list stuck and turns the two laws below into
# inductions rather than computations.

# Whether two numbers are the same. It steps one successor off both of its
# arguments at once, so `eq(x, x)` on a variable `x` does not reduce -- that it
# is `True{}` is a fact about `x` and not an unfolding.
def eq(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          True{}
        case 1n+bp:
          False{}
    case 1n+ap:
      match b:
        case 0n:
          False{}
        case 1n+bp:
          eq(ap, bp)

# `xs` followed by `ys`, the prelude's own concatenation. It matches on its
# first argument, so with a variable `xs` the result does not reduce.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
