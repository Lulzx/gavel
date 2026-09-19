# HAND MUTANT (2026-09-19, tag g1). Target: `count_inv_cons`. A step is the
# head's own contribution *plus* the inversions inside the tail; this body keeps
# only the head's contribution, which is what a body that read the law as "count
# the elements below the head" and stopped there looks like. The two anchors are
# untouched.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-count-inv-laws --solution <this file> --proof
# references/t2-count-inv-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["count_inv_cons", "count_inv_replicate"]`. The second is not a
# second opinion: the step of the inductive law's proof reads the run of copies
# as a cons cell in front of a shorter run, and this body writes no recursion
# there, so the goal has no `S.count_inv(...)` term for the step to rewrite.
import Base
import ./prelude.bend as P

def count_inv(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      P.count_gt(h, t)
