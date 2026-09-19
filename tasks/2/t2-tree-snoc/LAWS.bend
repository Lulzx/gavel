import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`, and the two whose
# statement uses the tree twice bind it `+`: `Tree is Data`, so the `+` is
# allowed on it, and with a bare `for t: P.Tree` the second occurrence is a
# second use of a Lone variable. `snoc_tree_rightmost` names its tree once and
# is written plain. Anything that is not the function the policy writes is
# `P.` -- the solution module re-exports nothing, so `S.rightmost` is not a
# name.

# LAW: the value the new leaf carries is the value at the rightmost leaf of the
# answer. The step is the hypothesis at the right subtree and nothing else,
# because `P.rightmost` descends the right spine and the recursion descends the
# same spine to put the leaf there. This is the law that rules out the identity
# body (`P.rightmost(t) == v` is stuck on a variable) and every body that
# appends at the left or that overwrites the leaf it arrives at.
law snoc_tree_rightmost:
  for t: P.Tree
  for v: Nat
  {P.rightmost(S.snoc_tree(t, v)) == v : Nat}

# LAW: the leftmost leaf of the answer is the leftmost leaf of the input. It is
# not implied by the law above: a body that rebuilds each node with a constant
# in place of its left subtree still puts `v` at the rightmost leaf, and this is
# the law that rejects it. The step is definitional at both constructors --
# `P.leftmost` never reaches the subtree the recursion rebuilds.
law snoc_tree_leftmost:
  for +t: P.Tree
  for v: Nat
  {P.leftmost(S.snoc_tree(t, v)) == P.leftmost(t) : Nat}

# LAW: the right spine grows by exactly one node. This is the law that pins the
# *shape*: a body that hangs the new leaf on top of the whole tree, or anywhere
# above the bottom of the right spine, keeps the rightmost leaf and the leftmost
# leaf where the two laws above want them, and this is the one that rejects it.
# Its step is the hypothesis at the right subtree -- the statement is written
# with the `1n` on the outside so that the two sides agree term for term after
# that rewrite, which `1n + P.right_spine(t)` does and `P.right_spine(t) + 1n`
# does not, because `Nat.add` matches on its first argument.
law snoc_tree_right_spine:
  for +t: P.Tree
  for v: Nat
  {P.right_spine(S.snoc_tree(t, v)) == 1n + P.right_spine(t) : Nat}
