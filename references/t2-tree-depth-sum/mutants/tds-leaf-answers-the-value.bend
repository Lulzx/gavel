import Base
import ./prelude.bend as P

# `tree_depth_sum` answers a leaf's value rather than the depth the leaf sits
# at.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutant that type-checks rewrites a recursive step, and the leaf case is an
# answer a match that has already stopped gives -- it never recurses, so no
# step rewrite reaches it, and `tree_depth_sum_leaf` was killed only by corpus
# entries that fail to type-check. This is the reference with that one case
# given a non-empty answer -- `v`, the value the leaf carries, instead of the
# depth `k` the walk was handed -- so it type-checks and every recursive call
# is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `tree_depth_sum_leaf`, `tree_depth_sum_three`.
def tree_depth_sum(t: P.Tree, +k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      k + tree_depth_sum(l, 1n + k) + tree_depth_sum(r, 1n + k)
