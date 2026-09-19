import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Leaf{v}` and the depth is the literal `0n`, so the outer match
# takes the leaf case and the inner match takes its empty case: both sides are
# `v`.
def L.tree_level_sum_leaf(v):
  {==}

# The depth in the law is `1n + k`, which the inner match steps into its
# successor case, where the leaf answers `0n`.
def L.tree_level_sum_leaf_deep(v, k):
  {==}

# The tree is a `P.Node`, so the outer match takes the node case, and the depth
# `1n + k` takes the successor case, which descends into both subtrees.
def L.tree_level_sum_node_step(l, key, r, k):
  {==}

# The depth is the literal `0n` and the tree is a variable, so the case split is
# on the tree: a leaf answers `v` and `P.root` reads `v`, and a node answers
# `key` and `P.root` reads `key`. Nothing is left over in either case, so no
# hypothesis is needed and the law is a case split rather than an induction.
def L.tree_level_sum_root(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, key, r}:
      {==}
