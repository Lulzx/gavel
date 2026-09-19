import Base
import ./prelude.bend as P

# `leaf_count_at` carries the depth into an interior node at depth zero: a node
# below the root descends to its subtrees the reference's way, but a node *at*
# the root hands both subtrees the depth `0n` instead of answering nothing, so
# the leaves that stand at depth one are counted at depth zero as well.
#
# This file exists for the law about depth zero at an interior node: the two
# anchors are about leaves, and the step law is stated at `1n + k`, so no law
# other than this one reaches a node whose depth is `0n`.
#
# Measured against this task's law set: tier 3, killed by `leaf_count_at_root`
# -- the only law that reaches an interior node at depth zero -- and by
# `leaf_count_at_mirror`, whose depth-zero branch has to be closed by
# computation on both sides at once and cannot be, because the two sides here
# descend two different trees.
def leaf_count_at(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          1n
        case 1n+kp:
          0n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          leaf_count_at(l, 0n) + leaf_count_at(r, 0n)
        case 1n++kp:
          leaf_count_at(l, kp) + leaf_count_at(r, kp)
