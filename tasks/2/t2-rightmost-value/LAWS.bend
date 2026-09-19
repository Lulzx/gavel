import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a bare leaf is its own rightmost leaf, so it answers the value it carries.
# Both sides compute, so this is definitional, and it is the absolute anchor: the
# right-hand side is a binder and calls no target. The step law below is stated
# at `P.Node{l, key, r}`, so it never reaches a leaf, and it is also the law that
# says the answer is a value the tree carries: a body that answered a constant,
# or a count of anything, is caught only here.
law rightmost_value_leaf:
  for v: Nat
  {S.rightmost_value(P.Leaf{v}) == v : Nat}

# LAW: at a node the walk descends the right subtree, and nothing else is read:
# the node's key is not the answer, and no leaf of the left subtree is to the
# right of anything in `r`. Both sides compute, so this is definitional too, and
# it is the law with the step: a body that answered the node's own key, or that
# descended the left subtree, or that walked both and combined them, leaves the
# two sides here unconvertible.
law rightmost_value_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.rightmost_value(P.Node{l, key, r}) == S.rightmost_value(r) : Nat}

# LAW: the rightmost leaf of a mirrored tree is the leftmost leaf of the tree, so
# the answer at `P.mirror(t)` is `P.leftmost(t)`. This is the law with content,
# and the one that observes the tree through something other than the recursion:
# its right-hand side calls no target. The tree is a variable, so `P.mirror` and
# `P.leftmost` are both stuck and the case split on the tree is the proof. A body
# that got the direction of the walk wrong -- descending `l` where `r` belongs --
# is separated here as well as by the step law, and a body that read a number
# anywhere other than the end of the right spine leaves the two sides
# unconvertible.
law rightmost_value_mirror:
  for t: P.Tree
  {S.rightmost_value(P.mirror(t)) == P.leftmost(t) : Nat}
