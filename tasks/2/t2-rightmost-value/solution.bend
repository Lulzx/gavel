import Base
import ./prelude.bend as P

# TODO(policy): implement. `rightmost_value(t)` is the value the tree's rightmost
# leaf carries -- the leaf reached by descending the right subtree at every
# interior node. An interior node's key is not part of the answer, and neither is
# anything in a left subtree.
#
# Recurse on the tree: `P.Leaf{v}` is a rightmost leaf and answers `v`;
# `P.Node{l, key, r}` answers what its right subtree answers, and does not read
# the left one. `P.leftmost` is the same walk the other way, and `P.mirror`
# exchanges the two sides at every node, which is what the third law is stated
# over.
def rightmost_value(t: P.Tree) -> Nat:
  ?TODO
