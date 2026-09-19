# HAND MUTANT (2026-09-19, tag g1). Target: `longest_run_len_cons` and the
# ground law `longest_run_len_one_pair`. This body never looks at the blocks: it
# recurses on the tail and floors the answer at one, which is right on every
# list whose blocks are all singletons and wrong as soon as two neighbours
# agree. It is the killer of the pair law: that law is the only place where a
# block of two has to be counted rather than floored.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-longest-run-laws --solution <this file> --proof
# references/t2-longest-run-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["longest_run_len_cons", "longest_run_len_one_pair"]`.
import Base
import ./prelude.bend as P

def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      Nat.max(1n, longest_run_len(t))
