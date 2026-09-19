import Base
import ./prelude.bend as P

# PROBE. The plausible wrong answer: a body that takes the largest *element*
# seen for the best rather than the largest *prefix sum* -- a head is folded
# into the running sum as the reference does, but the best is compared against
# the head instead of against the new sum. It is the reading a policy that heard
# "the largest ... of the list" and never noticed the word prefix would write,
# and it is the body `mpg_cons` exists to separate. Read the verdict: **tier 3**
# means the law set catches it; tier 4 means the task pays full reward for it
# and the law set has a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-max-prefix-sum --solution <this file> --proof
# references/t2-max-prefix-sum/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["mpg_cons", "max_prefix_sum_three"]`. No hole: the walk's
# empty case and the wrapper's seed are untouched, so the three laws that name
# them survive, and the two laws that reach the step are the ones that fall.
def max_prefix_sum_go(xs: List<&2, Nat>, +acc: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      max_prefix_sum_go(t, Nat.add(acc, h), P.max2(h, best))

def max_prefix_sum(xs: List<&2, Nat>) -> Nat:
  max_prefix_sum_go(xs, 0n, 0n)
