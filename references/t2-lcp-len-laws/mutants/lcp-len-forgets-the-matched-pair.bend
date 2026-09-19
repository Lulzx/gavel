# HAND MUTANT (2026-09-19, tag g1). Target: `lcp_len_cons` and the ground law
# `lcp_len_equal_singletons`. This body keeps the equality test but drops the
# element it has just matched: the walk still stops where the lists differ, and
# every prefix it reports is one too short, with the prefix of a single equal
# pair reported as zero. It is the mutant that says the ground law is doing work
# rather than restating the empty anchors.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-lcp-len-laws --solution <this file> --proof
# references/t2-lcp-len-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["lcp_len_equal_singletons", "lcp_len_cons", "lcp_len_self"]`.
import Base
import ./prelude.bend as P

def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          P.gate(P.is_eq(h, k), lcp_len(t, u))
