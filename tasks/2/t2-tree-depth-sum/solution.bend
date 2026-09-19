import Base
import ./prelude.bend as P

# TODO(policy): implement. `tree_depth_sum(t, k)` adds `k` to the depth of every
# node of `t`, so the answer at `k = 0n` is the sum of the depths themselves. A
# leaf is one node and answers `k`. A node answers `k` for itself and then the
# two subtrees walked one level further down -- `1n + k` rather than `k` -- and
# adds the two answers. The depth is read three times in the node case, once for
# the node and once per subtree, so it is declared reusable: `+k`.
def tree_depth_sum(t: P.Tree, +k: Nat) -> Nat:
  ?TODO
