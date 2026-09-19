import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemma the content law needs is the policy's
# to write.

# The task's own tree, declared here and not in `solution.bend`: the policy
# never has to name a constructor context, and the type is the same one the laws
# quantify over. The constructors are reached through the prelude alias --
# `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# The list vocabulary the laws are stated in. All of it is `List<&2, Nat>` so
# that a destructured tail can be marked reusable; `append` matches on its first
# argument, so with a variable list the goals do not reduce.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The leaf values of the tree, left to right. It is the sequence the fold is
# measured against: the fold reads the same leaves in the same order, and
# `tree_fold` answers that sequence with the accumulator stuck on the end.
def flatten(t: Tree) -> List<&2, Nat>:
  match t:
    case Leaf{v}:
      v <> Nil{}
    case Node{l, r}:
      append(flatten(l), flatten(r))
