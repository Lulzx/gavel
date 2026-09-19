import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Leaf{v}` and both sides are `k`: the outer match takes the
# leaf case, which ignores `v` and answers the depth it was handed.
def L.tree_depth_sum_leaf(v, k):
  {==}

# The tree is a `P.Node`, so the outer match takes the node case, which spends
# `k` on the node and hands `1n + k` to both subtrees: the two sides are the
# same term.
def L.tree_depth_sum_node(l, key, r, k):
  {==}

# The tree is closed, so both matches reduce: the root spends `0n` on itself and
# hands `1n + 0n` to two leaves, each of which answers the depth it was handed.
# What is left is `0n + 1n + 1n`, which is the numeral `2n` on both sides.
def L.tree_depth_sum_three():
  {==}
