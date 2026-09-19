# HAND MUTANT (2026-09-19, tag g1). Target: `longest_run_len_cons`. The step is
# the better of the block that starts at the first element and the longest run
# inside the tail; this body keeps only the first block, which is what a body
# that read `P.run_len` as the whole answer looks like. The anchors and the two
# ground laws are untouched, because the three-element no-pair list has every
# block equal to one and the pair list's first block is the answer.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-longest-run-laws --solution <this file> --proof
# references/t2-longest-run-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["longest_run_len_cons"]` -- the first block is the answer on
# every input the ground laws name, so the step law is the only one it fails.
import Base
import ./prelude.bend as P

def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      P.run_len(h <> t)
