import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `is_nil`, `eq`, `eq_list` and `append`, so the policy's
# `is_suffix` may lean on them. The lists are `List<&2, Nat>` -- with the
# element many, a binder of the list can be marked `+` and read twice, which is
# what a walk that both offers the whole list and steps past its head needs.
# Each helper matches on its first argument, which is what leaves a goal about
# it at a variable list stuck and turns the laws below into inductions rather
# than computations.

# Whether a list is empty. It matches on its first argument, so a goal that
# needs to know the answer for a list it cannot name does not reduce.
def is_nil(xs: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      False{}

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

# Whether two lists of numbers are the same list, element for element. It steps
# one cons cell off both of its arguments at once, so `eq_list(xs, xs)` on a
# variable `xs` does not reduce either.
def eq_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          True{}
        case k <> u:
          False{}
    case +h <> +t:
      match ys:
        case Nil{}:
          False{}
        case +k <> +u:
          Bool.and(eq(h, k), eq_list(t, u))

# `xs` followed by `ys`, the prelude's own concatenation. It matches on its
# first argument, so with a variable `xs` the result does not reduce.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case +h <> +t:
      h <> append(t, ys)
