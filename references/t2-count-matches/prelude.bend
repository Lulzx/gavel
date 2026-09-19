import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `eq`, `pick` and `len`, so the policy's `count_matches` may lean
# on them. All three match on their first argument, which is what leaves a goal
# about any of them at a variable stuck and turns the content law below into an
# induction rather than a computation.

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

# `a` when `c` is true, and `b` otherwise. It matches on its first argument, so
# with a variable `c` the result does not reduce: the laws can name a weight
# without the policy's comparison having to be transparent.
def pick(c: Bool, a: Nat, b: Nat) -> Nat:
  match c:
    case True{}:
      a
    case False{}:
      b

# The number of elements in `xs`. It matches on its first argument, so with a
# variable `xs` the result does not reduce.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
