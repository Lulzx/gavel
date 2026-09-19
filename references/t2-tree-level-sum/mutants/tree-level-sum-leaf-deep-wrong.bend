# Hand-written mutant for `tree_level_sum_leaf_deep`: the reference with a leaf
# answering its own value at every depth below zero instead of `0n`. This is the
# plausible wrong body the second anchor exists for -- a leaf counted once per
# level rather than once at depth zero.
#
# Measured 2026-09-19: tier 3, laws_failed = ["tree_level_sum_leaf_deep"]. The
# step law and the other two anchors still hold, because both sides of the step
# read the same (wrong) leaf answer.
import Base
import ./prelude.bend as P

def tree_level_sum(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          v
        case 1n+kp:
          v
    case P.Node{l, key, r}:
      match k:
        case 0n:
          key
        case 1n++kp:
          tree_level_sum(l, kp) + tree_level_sum(r, kp)
