import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `run_starts_nil`. An empty list has no positions, so the
# answer is `Nil{}`; this body opens a run at `0n` there instead -- the reading
# that puts the first position down before looking at the list at all, so that
# "position `0n` always opens one" is applied to the empty list too. It is the
# answer of the outer match's first case, which the generated corpus's step
# rewrites never reach, and it is the only law that separates this body: the
# walk itself is untouched and every other law reads a non-empty list.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-run-starts --solution <this file> --proof
# references/t2-run-starts/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["run_starts_nil"]`. One law, and it is the whole kill list:
# the walk is the reference's, and every other law here reads a list with at
# least one element.
def run_starts_go(rest: List<&2, Nat>, prev: Nat, +i: Nat) -> List<&2, Nat>:
  match rest:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.put_start(i, run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev))

def run_starts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      0n <> run_starts_go(t, h, 1n)
