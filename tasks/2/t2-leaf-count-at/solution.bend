import Base
import ./prelude.bend as P

# TODO(policy): implement. `leaf_count_at(t, k)` is the number of leaves the tree
# carries at depth `k`, counting the root as depth `0n`, and `0n` wherever the
# tree is shallower than `k`. The number at a leaf is a value the tree carries,
# not a leaf of its own: a leaf is one leaf, and an interior node is not a leaf
# at all, so a count is not a sum and the key an interior node carries is never
# read.
#
# Recurse on the tree first and on the depth second. `P.Leaf{v}` answers `1n` at
# depth `0n` and `0n` at every depth `1n + kp`. `P.Node{l, key, r}` answers `0n`
# at depth `0n`, and otherwise hands `kp` to both subtrees and adds the two
# answers.
def leaf_count_at(t: P.Tree, k: Nat) -> Nat:
  ?TODO
