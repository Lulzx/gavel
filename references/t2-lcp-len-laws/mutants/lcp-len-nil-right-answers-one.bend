# HAND MUTANT (2026-09-19, tag g1). Target: `lcp_len_nil_right`. The right list
# running out ends the walk too, and this body charges one for it. It is the
# branch the generated corpus never reaches: with the left list a variable the
# outer match is stuck, so the law is inductive and the killer has to be a body
# that breaks this branch rather than the shape of the recursion.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-lcp-len-laws --solution <this file> --proof
# references/t2-lcp-len-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["lcp_len_nil_right"]` -- one law, the one named above, which
# makes this the mutant that isolates it.
import Base
import ./prelude.bend as P

def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          1n
        case k <> u:
          P.gate(P.is_eq(h, k), 1n + lcp_len(t, u))
