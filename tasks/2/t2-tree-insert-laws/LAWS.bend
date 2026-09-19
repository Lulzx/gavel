import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`, and two of them are stated
# *at* a `P.Tree` rather than at a `Nat` -- the answer the policy's function
# returns is a tree, so the equations are between trees. Anything that is not
# the function the policy writes is `P.` -- the solution module re-exports
# nothing, so `S.flatten` is not a name.

# LAW: a leaf becomes a node whose two children are the number being inserted
# and the number that was there. Both sides compute, so this is definitional,
# and it is the anchor: the step law below is stated at `P.Node{l, r}`, so it
# never reaches a leaf, and a body whose leaf case answered anything but a node
# built those two ways -- the leaf itself, or a node with the children the other
# way round -- is caught only here. It is also the law that says the answer
# *grows*: the number that was at the leaf is still in the tree, one level
# further down.
law tree_insert_leaf:
  for w: Nat
  for v: Nat
  {S.tree_insert(P.Leaf{w}, v) == P.Node{P.Leaf{v}, P.Leaf{w}} : P.Tree}

# LAW: at a node the insertion goes into the left subtree and the right subtree
# is left standing. Both sides compute, so this is definitional too, and it is
# the law that says the descent is to the *left*: a body that descended the
# right subtree instead is separated here on any tree whose subtrees differ. It
# is also the law that fixes the rest of the answer's shape, so together with
# the anchor above it determines the function on every tree.
law tree_insert_node:
  for l: P.Tree
  for r: P.Tree
  for v: Nat
  {S.tree_insert(P.Node{l, r}, v) == P.Node{S.tree_insert(l, v), r} : P.Tree}

# LAW: the numbers the inserted tree carries are the new number and then the
# numbers the old tree carried, in that order. `P.flatten` reads the leaves left
# to right and `P.append` is given in the prelude, so the right-hand side is an
# absolute reading of both trees and never mentions `tree_insert` or its
# recursion. It is the law that states what an insertion *means* rather than how
# it is done: the two laws above fix the recursion case by case, and this one
# names the property those cases were chosen to give, in terms of the numbers
# alone. It is the law that says no number is lost and none is invented -- a
# body that dropped the old leaf, or that copied it twice, or that put the new
# number after the old list, leaves the two sides unequal as lists of numbers.
# The tree is a variable,
# so `P.flatten` does not reduce: this one is the induction, and it does not
# close definitionally, because after the hypothesis lands one side has the new
# number in front of the old list and the other has it in front of the appending
# of the two subtrees' lists -- which is one unfolding of `P.append` on a cons
# and so needs no lemma of its own, but it is not the identity the pins close
# with.
law tree_insert_flatten:
  for +t: P.Tree
  for v: Nat
  {P.flatten(S.tree_insert(t, v)) == v <> P.flatten(t) : List<&2, Nat>}
