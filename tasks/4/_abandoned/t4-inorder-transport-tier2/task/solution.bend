import Base
import ./prelude.bend as P

# TODO(policy): the keys of `t`, left to right -- the inorder traversal, as a
# `List<&2, Nat>`.
#
# The order is not a matter of taste, and `inorder_node` is where it is stated:
# the traversal of a node is the left subtree's traversal, then the key, then
# the right subtree's. Nothing else can say it -- the transport is a conjunction
# over a fold that is blind to permutations, and the measure only counts -- so a
# body that put the key in front of the left subtree would satisfy both of them.
def inorder(t: P.Tree) -> List<&2, Nat>:
  ?TODO
