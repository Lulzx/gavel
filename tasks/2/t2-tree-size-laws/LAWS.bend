import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`. `tree_size_nodes` binds its
# tree once and is written plain; the other two name a constructor, so a tree
# bound there would only be a variable inside a pattern and needs no mark.
# Anything that is not the function the policy writes is `P.` -- the solution
# module re-exports nothing, so `S.nodes` is not a name.

# LAW: a leaf is one node. Both sides compute, so this is definitional, and it
# is the anchor: the step law below is stated at `P.Node{l, key, r}`, so it
# never reaches a leaf, and a body whose leaf case answered `0n` -- or the
# leaf's own value, or anything but `1n` -- is caught only here. It is the one
# law in this set whose right-hand side does not call the target.
law tree_size_leaf:
  for v: Nat
  {S.tree_size(P.Leaf{v}) == 1n : Nat}

# LAW: a node is itself one node in addition to its two subtrees. Both sides
# compute, so this is definitional too, and it is the law that says the answer
# is built from *both* subtrees: a body that descended one side only -- `1n +
# S.tree_size(l)` for the `Node` case -- leaves the two sides here
# unconvertible on any tree whose subtrees differ.
law tree_size_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.tree_size(P.Node{l, key, r}) == 1n + S.tree_size(l) + S.tree_size(r) : Nat}

# LAW: the size is how many entries `P.nodes` lists. This is the law with
# content, and the one that observes the tree rather than itself: `P.nodes`
# reads every node's own value, so a body that counted only the leaves, or that
# counted the interior nodes only, is separated here even though the two laws
# above are both satisfied by the recursion it would take. The tree is a
# variable, so `P.nodes` does not reduce and neither does `P.len`: this one is
# the induction, and it does not close definitionally, because after the two
# hypotheses land one side has the two counted lists added and the other has
# them appended, so the length of `P.append` is a list lemma the prelude does
# not have.
law tree_size_nodes:
  for t: P.Tree
  {S.tree_size(t) == P.len(P.nodes(t)) : Nat}
