# Hand-written mutant for the base-case rule: `tree_level_sum_leaf` is one of the
# two laws whose left-hand side is at a closed term, and no generated mutant
# reaches its answer. The reference with its leaf-at-depth-zero case answering
# `0n` instead of the leaf's value.
#
# Measured 2026-09-19: tier 3, laws_failed = ["tree_level_sum_leaf",
# "tree_level_sum_root"] -- a leaf with no value is also a root with no value,
# so the two anchors fall together here.
import Base
import ./prelude.bend as P

def tree_level_sum(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          0n
        case 1n+kp:
          0n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          key
        case 1n++kp:
          tree_level_sum(l, kp) + tree_level_sum(r, kp)
