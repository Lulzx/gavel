# Hand-written mutant for `tree_level_sum_root`, the only law that reaches a node
# at depth zero. The reference with the node-at-depth-zero case answering `0n`
# instead of the node's own key. Nothing else looks at a node at depth zero: the
# step law is stated at `1n + k`, and both leaf laws name `P.Leaf`.
#
# Measured 2026-09-19: tier 3, laws_failed = ["tree_level_sum_root"].
import Base
import ./prelude.bend as P

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
          0n
        case 1n++kp:
          tree_level_sum(l, kp) + tree_level_sum(r, kp)
