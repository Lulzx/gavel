import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The function rebuilds a constructor at each step and never reduces what is
# under it, so both of the first two laws are definitional: the leaf case
# answers a node of two leaves and the node case answers a node of the rewritten
# left subtree and the untouched right one.
def L.tree_insert_leaf(w, v):
  {==}

def L.tree_insert_node(l, r, v):
  {==}

# The induction is in the tree. The leaf case is definitional: the inserted tree
# is a node of two leaves, and flattening it is the new number, then the old
# one. The node case unfolds to a `P.append` of the rewritten left subtree's
# reading against the right subtree's, and the hypothesis at the left subtree
# says exactly that the first of those is the new number in front of the old
# reading.
#
# The hypothesis is used flipped. It reads left to right as `flatten` of an
# `insert` equals the number consed onto a `flatten`, and the goal has the
# `flatten`-of-an-`insert` on the *left* and the consed form on the right, so
# the rewrite has to put the consed form where the flatten-of-an-insert sits.
# That is `Equal.sym`, whose equation points the way the rewrite has to go; the
# hole is the first argument of the `P.append` on the left. What is left is one
# unfolding of `P.append` on a cons -- the first argument of that append is now
# `v <> P.flatten(l)`, a constructor, so `P.append` steps and both sides become
# the same term.
def L.tree_insert_flatten(t, v):
  match t:
    case P.Leaf{w}:
      {==}
    case P.Node{+l, +r}:
      %Equal.sym(List<&2, Nat>, P.flatten(S.tree_insert(l, v)), v <> P.flatten(l), L.tree_insert_flatten(l, v))
          : {P.append(_, P.flatten(r)) == v <> P.append(P.flatten(l), P.flatten(r)) : List<&2, Nat>}
      {==}
