import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `run_lengths_nil`. An empty list has no runs, so the
# answer is the empty list; this body answers a single cell holding `0n` -- the
# reading a policy that emits a run for the input before it has read anything
# has. It is otherwise the reference, and no other law here looks at the empty
# input through `run_lengths`: the walk's own empty-tail answers are reached with
# a non-empty list in front of them, and the singleton case is the other branch
# of the same match. The generator cannot reach this answer at all -- its
# rewrites only change what a step passes on, and this is the branch a step never
# reaches -- which is why the law would otherwise have no kill.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-run-lengths --solution <this file> --proof references/t2-run-lengths/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["run_lengths_nil"]`, and
# the checker's own words are `expected : [0n]` against `observed : []` -- the
# single law this body is here to guard.
def run_lengths_go(t: List<&2, Nat>, cont: Bool, cur: Nat, h: Nat) -> List<&2, Nat>:
  match t:
    case Nil{}:
      match cont:
        case True{}:
          (1n + cur) <> Nil{}
        case False{}:
          cur <> (1n <> Nil{})
    case +h2 <> +t2:
      match cont:
        case True{}:
          run_lengths_go(t2, P.same(h, h2), 1n + cur, h2)
        case False{}:
          cur <> run_lengths_go(t2, P.same(h, h2), 1n, h2)

def run_lengths(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      match t:
        case Nil{}:
          1n <> Nil{}
        case +h2 <> +t2:
          run_lengths_go(t2, P.same(h, h2), 1n, h2)
