import Base
import ./prelude.bend as P

# Counts nodes rather than edges, so a leaf is one tall instead of zero. The step
# is the reference's and every nonempty tree is still one more than its subtrees,
# so `height_node` holds; `height_mirror` holds too, because mirroring preserves
# the node count and both sides gain the same amount. That is what makes this the
# useful one in the corpus: `height_leaf`, the law that fixes the bottom of the
# recursion, is the only law that can see it, and it rejects `1n` against `0n`.
def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      1n
    case P.Node{l, r}:
      1n + P.max(height(l), height(r))
