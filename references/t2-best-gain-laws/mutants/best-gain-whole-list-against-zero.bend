# HAND MUTANT (2026-09-19, tag g1). Target: `best_gain_pair`, `best_gain_single`
# and `best_gain_cons`. This body measures the wrong thing with the right
# vocabulary: it takes the prelude's rise from `0n` over the whole list, which
# is the largest element rather than the largest rise between two of them, and
# it never recurses. It is a wrong function rather than a broken step, so it is
# the mutant that says whether the anchors and the pair law pull their weight.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-best-gain-laws --solution <this file> --proof
# references/t2-best-gain-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["best_gain_single", "best_gain_cons", "best_gain_pair"]`. The
# empty law survives it -- the largest element of nothing is zero -- which is
# what makes this one the reading of what the anchors are for.
import Base
import ./prelude.bend as P

def best_gain(xs: List<&2, Nat>) -> Nat:
  P.max_sub(0n, xs)
