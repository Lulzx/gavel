# HAND MUTANT (2026-09-19, tag g1). Target: the two ground laws and
# `longest_run_len_single` and `longest_run_len_cons`. This body measures the
# right blocks and reports every one of them one short, so it agrees with the
# empty list and disagrees with everything that has an element in it: the
# singleton, the pair, and the no-pair triple are all off by one, and the step
# law cannot convert.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-longest-run-laws --solution <this file> --proof
# references/t2-longest-run-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["longest_run_len_single", "longest_run_len_cons",
# "longest_run_len_one_pair", "longest_run_len_no_pair"]`. Only the empty law
# survives it.
import Base
import ./prelude.bend as P

def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      Nat.max(Nat.sub(P.run_len(h <> t), 1n), longest_run_len(t))
