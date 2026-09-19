import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the tree and the inner match is
# on the depth, so that the depth decides what a *node* contributes. At depth
# zero a node carries the answer itself -- its key -- and at `1n + kp` it hands
# `kp` to both subtrees and adds what they answer. A leaf answers its value at
# depth zero and `0n` at every depth below, which is the case the depth is not
# enough to tell from a node's.
def tree_level_sum(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          v
        case 1n+kp:
          0n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          key
