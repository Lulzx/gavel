import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `max_gap_nil`. A list with no elements has no neighbouring
# pair, so the answer is `0n`; this body answers `1n` there -- the reading that a
# gap is *counted* rather than measured, so that spanning nothing is still worth
# one. It is the answer of the outer match's first case, which the generated
# corpus's step rewrites never reach, and it is the only law that separates this
# body: every other law here reads a list with at least one element, and the walk
# itself is untouched.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-max-gap --solution <this file> --proof references/t2-max-gap/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["max_gap_nil"]`. One law,
# and it is the whole kill list -- the law that had no other killer.
def gap_go(xs: List<&2, Nat>, prev: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      gap_go(t, h, Nat.max(P.absdiff(prev, h), best))

def max_gap(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      gap_go(t, h, 0n)
