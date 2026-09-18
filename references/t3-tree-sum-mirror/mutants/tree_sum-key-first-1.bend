import Base
import ./prelude.bend as P

# The key is counted, but it is added before the left subtree instead of after
# it. Addition on `Nat` folds on its first argument, so the two orderings are
# not convertible while the summands are variables, and `tree_sum_node` rejects
# this: its right side is `(S.tree_sum(l) + key) + S.tree_sum(r)` and this
# computes to `(key + S.tree_sum(l)) + S.tree_sum(r)`. The sum is the same
# number, and that is not the question the checker asks.
def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, key, r}:
      key + tree_sum(l) + tree_sum(r)
