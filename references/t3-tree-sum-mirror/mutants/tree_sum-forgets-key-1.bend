import Base
import ./prelude.bend as P

# Sums the subtrees and drops the node's own key. The leaf case is the
# reference's, so `tree_sum_leaf` holds; `tree_sum_node` rejects it, its right
# side carrying `key` where this computes to `S.tree_sum(l) + S.tree_sum(r)`.
# The mirror law rejects it as well, and that one is worth reading twice: a
# mirror does not change a sum of subtree sums, so the law is *true* of this body
# and the reference proof still fails against it, because the induction cannot
# unfold a body that never mentions the key.
def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, key, r}:
      tree_sum(l) + tree_sum(r)
