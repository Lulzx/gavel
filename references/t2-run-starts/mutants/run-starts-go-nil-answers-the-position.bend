import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `run_starts_go_nil`. The walk's empty case has nothing
# left to open, so it answers `Nil{}`; this body puts its position down there
# instead -- the reading that opens a run at the position *after* the last
# element, which is what a walk that decided first and recursed second would
# produce. It is the answer of the walk's own first case, which no recursive-step
# rewrite reaches: the generated corpus never exercises this law, and the two
# closed laws plus the single-element law go with it, because every walk ends
# with an extra position on the end.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-run-starts --solution <this file> --proof
# references/t2-run-starts/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["run_starts_single", "run_starts_go_nil",
# "run_starts_three"]`. Three laws: the walk's own anchor, and the two laws
# whose lists are short enough that the walk's empty case is reached.
def run_starts_go(rest: List<&2, Nat>, prev: Nat, +i: Nat) -> List<&2, Nat>:
  match rest:
    case Nil{}:
      i <> Nil{}
    case +h <> t:
      P.put_start(i, run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev))

def run_starts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      0n <> run_starts_go(t, h, 1n)
