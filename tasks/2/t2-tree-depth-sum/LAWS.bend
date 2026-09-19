import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a leaf is one node, and it sits at whatever depth the walk was handed, so
# its contribution is `k` itself. Both sides compute, so this is definitional,
# and it is the absolute anchor: the right-hand side is a binder and calls no
# target. It is also the law that separates this function from a level sum --
# the step law below never reaches a leaf, so a body that answered the leaf's
# *value* here satisfies every other law in this file.
law tree_depth_sum_leaf:
  for v: Nat
  for k: Nat
  {S.tree_depth_sum(P.Leaf{v}, k) == k : Nat}

# LAW: a node contributes its own depth and both subtrees are walked one level
# further down. Both sides compute, so this is definitional, and it is the law
# with the step: a body that carried `k` unchanged into the subtrees -- the
# level sum's shape -- answers `k + k` here rather than `k + (1n + k)`, and a
# body that descended one side only is separated by the same two sides. The
# tree is a variable in the recursion and the depth here is a variable too, so
# nothing about the shape of a particular tree is baked in.
law tree_depth_sum_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  for +k: Nat
  {S.tree_depth_sum(P.Node{l, key, r}, k) == k + S.tree_depth_sum(l, 1n + k) + S.tree_depth_sum(r, 1n + k) : Nat}

# LAW: one closed tree, read at the root. The two laws above fix the walk at
# every shape of argument; this one fixes, on a tree both of whose subtrees are
# leaves, what the numbers come to: the root sits at depth zero and the two
# leaves at depth one, so the sum is `2n` -- not the node's key, and not a count
# of nodes.
law tree_depth_sum_three:
  {S.tree_depth_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 0n) == 2n : Nat}
