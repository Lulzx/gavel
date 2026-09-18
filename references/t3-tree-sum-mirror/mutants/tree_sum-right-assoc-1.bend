import Base
import ./prelude.bend as P

# The same three summands in the same left-to-right order, bracketed to the
# right instead of to the left. This is associativity, which holds for numbers
# and not for convertibility: `Nat.add` folds on its first argument, so
# `S.tree_sum(l) + (key + S.tree_sum(r))` is stuck against the law's
# `(S.tree_sum(l) + key) + S.tree_sum(r)`. The one-line parenthesisation costs
# the whole task, and `tree_sum_node` is the law that charges for it.
def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, key, r}:
      tree_sum(l) + (key + tree_sum(r))
