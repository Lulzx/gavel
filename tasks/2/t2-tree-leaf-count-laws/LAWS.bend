import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`. The third binds its tree
# with `+`: its statement uses the tree twice -- once as the recursive call and
# once inside `P.flatten` -- which a Lone variable cannot do. `Tree is Data`, so
# the `+` is allowed on it. Anything that is not the function the policy writes
# is `P.` -- the solution module re-exports nothing, so `S.flatten` is not a
# name.

# LAW: a leaf is one leaf. Both sides compute, so this is definitional, and it
# is the anchor: the step law below is stated at `P.Node{l, r}`, so it never
# reaches a leaf, and a body whose leaf case answered `0n` -- or the leaf's own
# value, or anything but `1n` -- is caught only here. It is the one law in this
# set whose right-hand side does not call the target.
law tree_leaf_count_leaf:
  for v: Nat
  {S.tree_leaf_count(P.Leaf{v}) == 1n : Nat}

# LAW: a node's leaves are the leaves of its two subtrees, and the node itself
# contributes none. Both sides compute, so this is definitional too, and it is
# the law that says the answer is built from *both* subtrees: a body that
# descended one side only leaves the two sides here unconvertible on any tree
# whose subtrees differ. It is also the law that says a node is not counted:
# a body that added `1n` for each interior node answers one more here than it
# should on every input with a node.
law tree_leaf_count_node:
  for l: P.Tree
  for r: P.Tree
  {S.tree_leaf_count(P.Node{l, r}) == S.tree_leaf_count(l) + S.tree_leaf_count(r) : Nat}

# LAW: the count is how many values `P.flatten` lists. This is the law with
# content, and the one that observes the tree rather than itself: `P.flatten`
# reads the leaf values, so a body that counted the interior nodes instead --
# the exact complement of this function -- is separated here even though the
# step law above is satisfied by the complement's own recursion. The tree is a
# variable, so `P.flatten` does not reduce and neither does `P.len`: this one
# is the induction, and it does not close definitionally, because after the two
# hypotheses land one side has the two counted lists added and the other has
# them appended, so the length of `P.append` is a list lemma the prelude does
# not have.
law tree_leaf_count_flatten:
  for +t: P.Tree
  {S.tree_leaf_count(t) == P.len(P.flatten(t)) : Nat}
