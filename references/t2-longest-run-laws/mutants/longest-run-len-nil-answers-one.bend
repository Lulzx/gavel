# HAND MUTANT (2026-09-19, tag g1). Target: `longest_run_len_nil`. An empty list
# has no element, so it has no block to measure; this body answers `1n` there
# instead. The generator rewrites steps and branch bodies it can reach, and this
# is the answer of a match that has already stopped on the empty list, so
# nothing generated arrives here -- the empty law has no killer in the generated
# corpus.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-longest-run-laws --solution <this file> --proof
# references/t2-longest-run-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["longest_run_len_nil"]` -- one law, the one named above, which
# makes this the mutant that isolates the anchor.
import Base
import ./prelude.bend as P

def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> +t:
      Nat.max(P.run_len(h <> t), longest_run_len(t))
