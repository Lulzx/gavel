# HAND MUTANT (2026-09-19, tag g1). Target: `best_gain_cons`. The step is the
# better of the head's rise into the tail and the tail's own gain; this body
# keeps only the head's rise, which is what a body that read "the best rise from
# the head" and stopped there looks like. The anchors are untouched.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-best-gain-laws --solution <this file> --proof
# references/t2-best-gain-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["best_gain_cons", "best_gain_pair"]`. The pair law goes too:
# its proof removes the `Nat.max` the step leaves around the head's rise, and
# this body leaves a `Nat.max` with no tail gain under it for the step to
# rewrite.
import Base
import ./prelude.bend as P

def best_gain(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      P.max_sub(h, t)
