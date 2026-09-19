# HAND MUTANT (2026-09-19, tag g1). Target: `lcp_len_cons`. This body counts
# every matched position without asking whether the elements agree, so it is
# right about a list against itself and right about every list running out, and
# wrong the moment two different heads meet a common prefix. It is the killer
# that isolates the comparison.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-lcp-len-laws --solution <this file> --proof
# references/t2-lcp-len-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["lcp_len_cons", "lcp_len_self"]`. The self law goes with it
# even though the body agrees with `P.len` on a list against itself: the step of
# that law's proof reads the gate the step law puts around the matched pair, and
# this body has no gate there to read.
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
          1n + lcp_len(t, u)
