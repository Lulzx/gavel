import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the tree and the inner match is
# on the depth, so that the depth decides what a node contributes. A leaf is one
# leaf at depth `0n` and nothing at every depth below it; an interior node is not
# a leaf at any depth, so at `1n + kp` it hands `kp` to both subtrees and adds
# the two answers, and at `0n` it contributes nothing. The key an interior node
# carries is not read: a count is not a sum.
def leaf_count_at(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          0n
        case 1n++kp:
          leaf_count_at(l, kp) + leaf_count_at(r, kp)

    case P.Node{l, key, r}:
      match k:
        case 0n:
          1n
        case 1n+kp:
          0n
