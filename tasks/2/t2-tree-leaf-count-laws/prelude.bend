import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemma that uses it is the policy's to write.

# The task's own tree. It is declared here and not in `solution.bend`, so the
# policy never has to name a constructor context, and the type is the same one
# the laws quantify over. The constructors are reached through the prelude
# alias -- `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike. The
# value sits at the leaf, so the leaves are the only places a number is stored
# and `P.flatten` is a list of exactly the values the leaves carry.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# `xs` followed by `ys`. It matches on its first argument, so with a variable
# list on the left the goal does not reduce, and that is what leaves the third
# law below to the induction rather than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The values at the leaves, left to right. One entry per leaf, so its length is
# the leaf count.
def flatten(t: Tree) -> List<&2, Nat>:
  match t:
    case Leaf{v}:
      v <> Nil{}
    case Node{l, r}:
      append(flatten(l), flatten(r))

# How many elements a list has.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
