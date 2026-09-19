import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the tree, the list the laws read it with, and the
# appending that list is built from. The policy implements neither.

# The task's own tree. It is declared here and not in `solution.bend`, so the
# policy never has to name a constructor context, and the type is the same one
# the laws quantify over. The constructors are reached through the prelude
# alias -- `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike. The
# number sits at the leaf, so a leaf is where a number lives and a node is only
# a joining of two trees.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# `xs` followed by `ys`. It matches on its first argument, so with a variable
# list on the left the goal does not reduce, and on a cons it unfolds to the
# head in front of the appending of the tail.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The values at the leaves, left to right. One entry per leaf, so the list shows
# every number the tree carries and the order they are reached in.
def flatten(t: Tree) -> List<&2, Nat>:
  match t:
    case Leaf{v}:
      v <> Nil{}
    case Node{l, r}:
      append(flatten(l), flatten(r))
