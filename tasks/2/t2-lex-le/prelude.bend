import Base

# Immutable, and owned by the task rather than the policy. `lex_le` is what the
# policy implements; everything here is the vocabulary the laws are stated in --
# the two comparisons the walk spends on the heads, and the concatenation the
# last law extends a list with.

# `eq(a, b)` is `True{}` when the two numbers are equal and `False{}` otherwise.
# It steps one successor off both of its arguments at once, so `eq(x, x)` on a
# variable `x` does not reduce: that it is `True{}` is a fact about `x` and not
# an unfolding.
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

# `lt(a, b)` is `True{}` when `a` is strictly below `b` and `False{}` otherwise,
# by the same descent on both arguments at once -- so it too is stuck on two
# variables, and the law that a number is not below itself is an induction
# rather than an unfolding.
def lt(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          False{}
        case 1n+bp:
          True{}
    case 1n+ap:
      match b:
        case 0n:
          False{}
        case 1n+bp:
          lt(ap, bp)

# `xs` followed by `ys`, the prelude's own concatenation. It matches on its
# first argument, so with a variable list on the left the result does not
# reduce.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
