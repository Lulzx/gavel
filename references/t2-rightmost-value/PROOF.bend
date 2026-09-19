import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Leaf`, so the match takes the leaf case, which answers the
# value the leaf carries: both sides are `v`.
def L.rightmost_value_leaf(v):
  {==}

# The tree is a `P.Node`, so the match takes the node case, which answers its
# right subtree's answer: the two sides are the same term, and neither the key
# nor the left subtree is read.
def L.rightmost_value_node(l, key, r):
  {==}

# The induction is in the tree. At a leaf `P.mirror` answers the same leaf and
# both sides are the value it carries. At a node `P.mirror` swaps the two
# subtrees, so the walk's step lands on `P.mirror(l)`, which is exactly the
# hypothesis at `l` -- and `P.leftmost`'s own step is the same subtree. The
# hypothesis is stated the way the goal needs it, so it is the last line.
def L.rightmost_value_mirror(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, key, r}:
      L.rightmost_value_mirror(l)
