# HAND MUTANT (2026-09-19, tag g1). Target: `best_gain_nil`. A list with no pair
# has no rise, so the gain over it is zero; this body answers `1n` there instead.
# The generator only rewrites a step or a branch body it can reach, and this
# branch is the answer of a match that has already stopped on the empty list, so
# nothing generated arrives here.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-best-gain-laws --solution <this file> --proof
# references/t2-best-gain-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["best_gain_nil", "best_gain_single", "best_gain_pair"]`. The
# singleton and the pair are downstream of the same branch: both reach the empty
# case through the tail.
import Base
import ./prelude.bend as P

def best_gain(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> +t:
      Nat.max(P.max_sub(h, t), best_gain(t))
