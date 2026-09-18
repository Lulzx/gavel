import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a leaf holds nothing. Both sides compute, so this is definitional, and
# it is the weak half: it fixes the bottom of the recursion, and a body that
# ignored the tree entirely would still satisfy it.
law tree_sum_leaf:
  {S.tree_sum(P.Leaf{}) == 0n : Nat}

# LAW: the step of the sum. Both sides compute, so this is definitional too, and
# it is the law that says the node's own key is counted: a body that added only
# the subtrees -- `S.tree_sum(l) + S.tree_sum(r)` -- agrees with the law below
# on any tree whose keys are all zero and leaves the two sides here
# unconvertible.
law tree_sum_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.tree_sum(P.Node{l, key, r}) == S.tree_sum(l) + key + S.tree_sum(r) : Nat}

# LAW: mirroring does not change the sum. The two subtrees are live twice in the
# step -- once as the recursive call the hypothesis replaces and once in the goal
# that is left over -- which is why the law binds `+t`. After the two hypotheses
# land the two sums have changed places around the key: `(s + key) + u` against
# `(u + key) + s`, which is arithmetic rather than anything about trees, and
# `Nat.add` folds on its first argument, so none of it is definitional.
law tree_sum_mirror:
  for +t: P.Tree
  {S.tree_sum(P.mirror(t)) == S.tree_sum(t) : Nat}
