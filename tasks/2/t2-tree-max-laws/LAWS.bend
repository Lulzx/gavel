import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`. The third binds its tree
# with `+`: its statement uses the tree twice -- once as the recursive call and
# once inside `P.flatten` -- which a Lone variable cannot do. `Tree is Data`, so
# the `+` is allowed on it. Anything that is not the function the policy writes
# is `P.` -- the solution module re-exports nothing, so `S.flatten` is not a
# name.

# LAW: at a leaf the answer is the number the leaf carries. Both sides are that
# number, so this is definitional, and it is the anchor: the step law below is
# stated at `P.Node{l, r}`, so it never reaches a leaf, and a body whose leaf
# case answered anything else -- `0n`, or `1n`, or the answer of the whole tree
# -- is caught only here. It is also the law that says the answer is a value the
# tree *carries* and not a count of anything: no amount of structure satisfies
# this law on every `v` unless the leaf's own number is returned.
law tree_max_leaf:
  for v: Nat
  {S.tree_max(P.Leaf{v}) == v : Nat}

# LAW: a node's answer is the larger of its two subtrees' answers. Both sides
# compute, so this is definitional too, and it is the law that says the answer
# is built from *both* subtrees: a body that descended one side only leaves the
# two sides here unconvertible on any tree whose subtrees differ. It is also the
# law that says the node contributes nothing of its own -- there is no number at
# an interior node to contribute -- so a body that added the subtree answers
# together, or that returned one of them unconditionally, fails here.
law tree_max_node:
  for l: P.Tree
  for r: P.Tree
  {S.tree_max(P.Node{l, r}) == P.max(S.tree_max(l), S.tree_max(r)) : Nat}

# LAW: the answer is the largest number the tree carries. `P.flatten` reads the
# leaves left to right and `P.max_all` takes the largest of a list, so the
# right-hand side is a reading of the tree's own numbers that never mentions
# `tree_max` or the recursion -- an absolute anchor rather than a relation
# between two of the target's own calls. It is the law that pins the answer's
# *value*: a body that returned, say, the number of leaves, or the largest leaf
# of the left subtree, satisfies neither this law nor the two above on every
# input, and the ones the pins alone leave open on a tree whose two subtrees
# agree are separated here. The tree is a variable, so `P.flatten` does not
# reduce and neither does `P.max_all`: this one is the induction, and it does
# not close definitionally, because after the two hypotheses land one side has
# the two subtree answers combined with `P.max` and the other is the largest of
# the appended list, so the fact that the largest of `xs` appended to `ys` is
# the larger of their largest is a list lemma the prelude does not have -- and
# it in turn needs the associativity of `P.max`, which is not an unfolding
# either.
law tree_max_flatten:
  for +t: P.Tree
  {S.tree_max(t) == P.max_all(P.flatten(t)) : Nat}
