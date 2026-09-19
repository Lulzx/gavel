import Base
import ./prelude.bend as P

# The reference: a leaf is the end of its own path and answers the value it
# carries. A node answers the two subtrees' sums, plus its own key counted once
# for each leaf beneath it -- `P.leaves` of the two subtrees added, which is the
# prelude's own count of the leaves the node has.
def path_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{+l, key, +r}:
      Nat.add(Nat.add(path_sum(l), path_sum(r)), Nat.mul(key, Nat.add(P.leaves(l), P.leaves(r))))
