# Hand-written mutant for the base-case rule: the ground law `count_runs_nil`
# has no other mutant. The reference solution with its empty case answering `1n`
# instead of `0n`, which no generated mutant reaches -- the empty case is an
# answer reached by a match that has already stopped, and the generator rewrites
# a step.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.f1.json check
# t2-count-runs-laws --solution <this file> --proof references/.../PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["count_runs_nil"]`.
import Base
import ./prelude.bend as P

def count_runs(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      match t:
        case Nil{}:
          1n
        case +h2 <> t2:
          P.nsub(1n, P.is_eq(h, h2)) + count_runs(h2 <> t2)
