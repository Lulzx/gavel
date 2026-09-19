import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the tree, and the depth the walk
# was handed is spent on the node itself before it descends. A leaf answers its
# depth and nothing else -- `v` is bound by the pattern and never read, which is
# what makes this a sum of depths rather than a level sum. A node answers `k`
# plus the two subtrees at `1n + k`, so every level below costs one.
def tree_depth_sum(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      k
