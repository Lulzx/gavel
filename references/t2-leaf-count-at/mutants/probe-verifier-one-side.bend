import Base
import ./prelude.bend as P

# PROBE. The tree is walked once, the depth still decides what a node
# contributes, a leaf is one leaf at depth zero and nothing below -- and every
# level of the descent is read on the left only. That is the slip a body written
# by recursing on the tree the way a list is recursed on makes: the list's tail
# is the only thing left to walk, so the two subtrees are never both read. It
# asks whether the law set pins the descent to *both* subtrees.
#
# Measured against this task's law set: tier 3, killed by
# `leaf_count_at_node_step` -- whose two sides name the two subtrees separately,
# so one of them is a term this body never produces -- and by
# `leaf_count_at_mirror`, which hands the same tree to both sides with its
# subtrees exchanged. It is NOT a hole: the law set pins the descent to both
# subtrees, and this body is the evidence.
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
          0n
        case 1n++kp:
          leaf_count_at(l, kp)
