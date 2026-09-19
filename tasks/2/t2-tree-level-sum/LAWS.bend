import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: at depth zero a leaf answers its own value. Both sides compute, so this
# is definitional, and it is one of the two laws whose right-hand side does not
# call the target -- the anchor. It is the only law that reaches a leaf at depth
# zero, and the step law below is stated at `1n + k` so it never gets there.
law tree_level_sum_leaf:
  for v: Nat
  {S.tree_level_sum(P.Leaf{v}, 0n) == v : Nat}

# LAW: a leaf is shallower than every depth above zero, so it answers nothing
# there. Both sides compute, so this is definitional too. Without it the body
# could answer the leaf's value at every depth and still satisfy every other law
# here: the depth-zero law says nothing about depth `1n + k`, and the step law
# never reaches a leaf.
law tree_level_sum_leaf_deep:
  for v: Nat
  for k: Nat
  {S.tree_level_sum(P.Leaf{v}, 1n + k) == 0n : Nat}

# LAW: below a node, depth `1n + k` is depth `k` of the two subtrees, added.
# Both sides compute, so this is definitional, and it is the law that says the
# answer is built from *both* subtrees and that descending costs exactly one
# level: a body that descended one side only leaves the two sides unconvertible
# on any tree whose subtrees differ, and a body that carried the same depth into
# the subtrees -- `1n + k` rather than `k` -- is separated here too.
law tree_level_sum_node_step:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  for k: Nat
  {S.tree_level_sum(P.Node{l, key, r}, 1n + k) == S.tree_level_sum(l, k) + S.tree_level_sum(r, k) : Nat}

# LAW: the depth-zero sum is the value at the root, whatever the tree is. This
# is the law with content, and the one that observes the tree rather than the
# recursion: `P.root` reads the value the tree carries at its own root, so a
# body that answered a node's key from one of its subtrees, or that answered a
# leaf's value here, is separated here even though every law above is satisfied
# by the recursion it would take. It is also the only law that reaches a node at
# depth zero. The tree is a variable, so nothing reduces and this one needs the
# case split rather than a computation.
law tree_level_sum_root:
  for t: P.Tree
  {S.tree_level_sum(t, 0n) == P.root(t) : Nat}
