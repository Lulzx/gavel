import Base

# Immutable, and owned by the task rather than the policy. All four are the
# plumbing a sliding window needs and none of them is the thing being asked
# for, so they live here where the laws can name them: a law that had to spell
# the pointer out itself would be restating the recursion rather than saying
# what the recursion is worth.
#
# Every one of them takes the list first. That is not a style choice: the
# checker wants the arguments of a self-call read left to right, with each one
# passed unchanged until one shrinks, and a helper that walks a list has to
# shrink *that* list, so the list has to be the column that moves.

# The first `n` elements of `xs`, or all of `xs` when it is shorter than that.
def take(xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          Nil{}
        case 1n+p:
          h <> take(t, p)

# `xs` without its first `n` elements, or the empty list when it is shorter.
def skip(xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          h <> t
        case 1n+p:
          skip(t, p)

# `xs` as seen from the window of length `k` that starts at its first element:
# the list has one element per window, because a window is still available while
# there are `k` elements left to take. `k = 0` is the empty list, which is what
# makes the empty case of the task's own function answer nothing.
def lookahead(xs: List<&2, Nat>, k: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      Nil{}
    case 1n+p:
      skip(xs, p)

# `xs` without its first element, or the empty list when it has none.
def tail(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      t
