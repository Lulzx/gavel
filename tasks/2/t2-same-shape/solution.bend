import Base
import ./prelude.bend as P

# TODO(policy): implement. `same_shape(t1, t2)` answers whether the two trees
# are built the same way, ignoring the values they carry: two leaves have the
# same shape, a leaf against a node does not, and two nodes have the same shape
# exactly when both pairs of subtrees do. The two subtrees are handed on
# together, so the walk steps the first tree and carries the second alongside
# it. The values -- a leaf's `value` and an interior `key` -- are bound by the
# patterns and never read.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  ?TODO
