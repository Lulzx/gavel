import Base
import ./prelude.bend as P

# PROBE. The leaf anchor holds and the node still adds its own depth, but it
# descends without spending a level -- the level-sum's shape. The node law is
# the only law that reaches an interior node, so this probe asks whether it
# really pins the increment.
def tree_depth_sum(t: P.Tree, +k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      k
    case P.Node{l, key, r}:
      k + tree_depth_sum(l, k) + tree_depth_sum(r, k)
