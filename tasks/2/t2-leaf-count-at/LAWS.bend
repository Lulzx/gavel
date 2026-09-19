import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a leaf is one leaf at depth zero. Both sides compute, so this is
# definitional, and it is one of the two laws whose right-hand side does not
# call the target -- the anchor. It is the only law that reaches a leaf at depth
# zero, and the step law below is stated at `1n + k` so it never gets there.
law leaf_count_at_leaf:
  for v: Nat
  {S.leaf_count_at(P.Leaf{v}, 0n) == 1n : Nat}

# LAW: a leaf is shallower than every depth above zero, so it contributes
# nothing there. Both sides compute, so this is definitional too, and its
# right-hand side is the constant the answer has to be. Without it the body
# could answer the leaf's `1n` at every depth and still satisfy every other law
# here: the depth-zero law says nothing about depth `1n + k`, and the step law
# never reaches a leaf.
law leaf_count_at_leaf_deep:
  for v: Nat
  for k: Nat
  {S.leaf_count_at(P.Leaf{v}, 1n + k) == 0n : Nat}

# LAW: below an interior node, depth `1n + k` is depth `k` of the two subtrees,
# added. Both sides compute, so this is definitional, and it is the law that
# says the answer is built from *both* subtrees and that descending costs
# exactly one level: a body that descended one side only leaves the two sides
# unconvertible on any tree whose subtrees differ, and a body that carried the
# same depth into the subtrees -- `1n + k` rather than `k` -- is separated here
# too. Nothing in it reads the key, because nothing in a count does.
law leaf_count_at_node_step:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  for k: Nat
  {S.leaf_count_at(P.Node{l, key, r}, 1n + k) == S.leaf_count_at(l, k) + S.leaf_count_at(r, k) : Nat}

# LAW: the depth-zero count is one at a leaf and zero at an interior node,
# whatever the tree is. This is the law with content, and the one that observes
# the tree rather than the recursion: `P.is_leaf` reads whether the tree has a
# leaf at its own root, so a body that counted a node as a leaf, or that read a
# subtree's answer at depth zero, is separated here even though every law above
# is satisfied by the recursion it would take. The tree is a variable, so
# nothing reduces and this one needs the case split rather than a computation.
law leaf_count_at_root:
  for t: P.Tree
  {S.leaf_count_at(t, 0n) == P.at_if(P.is_leaf(t), 1n, 0n) : Nat}

# LAW: a count of leaves at a depth cannot see a tree from its mirror image.
# Swapping the two subtrees at every node moves every leaf to the other side of
# its own level and leaves its depth alone, so this is the law that says the
# answer is about the *depth* of a leaf and not about which side of the tree it
# hangs on. It is the induction here: the step descends into both subtrees, at
# one level below, and it needs both hypotheses -- which is what makes it the
# law that pins the descent, since a body that read only one subtree at each
# level answers the same thing for two trees that differ only in the side their
# leaves are on, and `P.mirror` is exactly the difference it does not see.
law leaf_count_at_mirror:
  for t: P.Tree
  for k: Nat
  {S.leaf_count_at(P.mirror(t), k) == S.leaf_count_at(t, k) : Nat}
