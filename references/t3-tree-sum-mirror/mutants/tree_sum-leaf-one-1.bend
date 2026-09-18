import Base
import ./prelude.bend as P

# Gives a leaf the value one instead of zero -- a node count where the task asks
# for a sum. The step is the reference's, so `tree_sum_node` holds, and so does
# `tree_sum_mirror`, because a mirrored tree has the same shape and so pays the
# same extra at every leaf. That makes this the useful one in the corpus:
# `tree_sum_leaf`, the law that fixes the bottom of the recursion, is the only
# law that can see it, and it rejects `1n` against `0n`.
def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      1n
    case P.Node{l, key, r}:
      tree_sum(l) + key + tree_sum(r)
