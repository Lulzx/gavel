# Hand-written mutant for `tree_level_sum_node_step`: the reference descending
# into the left subtree only. The law that says the answer is built from *both*
# subtrees, and the only one that can see this body -- both sides of the root law
# agree on it, because the root law is at depth zero and this drops the right
# subtree only below a node.
#
# Measured 2026-09-19: tier 3, laws_failed = ["tree_level_sum_node_step"].
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
          key
        case 1n++kp:
          tree_level_sum(l, kp)
