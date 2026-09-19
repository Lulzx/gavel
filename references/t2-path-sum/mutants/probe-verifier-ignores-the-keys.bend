import Base
import ./prelude.bend as P

# PROBE. The plausible wrong answer: a body that reads `path_sum` as the sum of
# the leaf values along the way and drops the interior keys entirely -- a leaf
# answers its value, a node just adds its two subtrees and never looks at its
# own key. It is the reading a policy that heard "the sum over all leaves" and
# stopped there would write, and it is the body the node law and the two closed
# laws exist to separate. Read the verdict: **tier 3** means the law set catches
# it; tier 4 means the task pays full reward for it and the law set has a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-path-sum --solution <this file> --proof references/t2-path-sum/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["path_sum_node",
# "path_sum_three", "path_sum_deep", "path_sum_zeroed"]`. No hole: the leaf
# anchor survives, because this body keeps the leaf's value, and every law that
# names an interior node separates it.
def path_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      Nat.add(path_sum(l), path_sum(r))
