import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas about `max` are the policy's to write.

# The task's own tree. It is declared here and not in `solution.bend`, so the
# policy never has to name a constructor context, and the type is the same one
# the laws quantify over. The constructors are reached through the prelude
# alias -- `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike. The
# number sits at the leaf, so the leaves are the only places a number is stored.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# The larger of two numbers. It steps on its first argument and then on its
# second, so on two variables neither side reduces -- which is what keeps the
# arithmetic facts about it out of the unfolding and makes them the policy's.
def max(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      match b:
        case 0n:
          1n+p
        case 1n+q:
          1n + max(p, q)

# `xs` followed by `ys`. It matches on its first argument, so with a variable
# list on the left the goal does not reduce.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The values at the leaves, left to right.
def flatten(t: Tree) -> List<&2, Nat>:
  match t:
    case Leaf{v}:
      v <> Nil{}
    case Node{l, r}:
      append(flatten(l), flatten(r))

# The largest element of a list, and `0n` on the empty list -- `0n` and not an
# error, so that `max_all` is a total function of the list alone. It is written
# from the right, so `max_all(h <> t)` is `max(h, max_all(t))` and the largest
# of a list sits at the top of a right-nested tower of `max`.
def max_all(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      max(h, max_all(t))
