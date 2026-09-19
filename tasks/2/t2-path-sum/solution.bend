import Base
import ./prelude.bend as P

# TODO(policy): implement. `path_sum(t)` adds up, over every leaf of `t`, the
# sum of the values on the path from the root down to that leaf: each leaf
# contributes its own value, and each interior key contributes once per leaf
# beneath it. A leaf is the end of its own path, so it answers its value. A node
# answers the two subtrees' sums -- every leaf beneath it counted once there --
# plus its own key, multiplied by the number of leaves the node has, which is
# `P.leaves` of the two subtrees added. `P.leaves` is the prelude's own count,
# so the policy names it rather than counting the tree again.
def path_sum(t: P.Tree) -> Nat:
  ?TODO
