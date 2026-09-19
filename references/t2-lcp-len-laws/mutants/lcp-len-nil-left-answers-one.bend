# HAND MUTANT (2026-09-19, tag g1). Target: `lcp_len_nil_left`. An empty list has
# no position to agree on, so the prefix with it is empty; this body answers `1n`
# at that branch instead. It is the answer of the outer match's empty case, which
# the generator's rules do not rewrite -- every generated mutant that touches the
# shape of the walk fails to type-check instead.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-lcp-len-laws --solution <this file> --proof
# references/t2-lcp-len-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["lcp_len_nil_left", "lcp_len_nil_right",
# "lcp_len_equal_singletons", "lcp_len_self"]`. The right-hand law goes too
# because its own empty case is this branch, and the singleton law counts one
# more than the single pair it has.
import Base
import ./prelude.bend as P

def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          P.gate(P.is_eq(h, k), 1n + lcp_len(t, u))
