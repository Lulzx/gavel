# HAND MUTANT (2026-09-19, tag g1). Target: `count_inv_nil`. The empty list has
# no pairs of positions, so it has no inversions; this body answers `1n` there
# instead. The generator only rewrites a step, and this is an answer reached by a
# match that has already stopped, so no generated mutant arrives here.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-count-inv-laws --solution <this file> --proof
# references/t2-count-inv-laws/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["count_inv_nil", "count_inv_single", "count_inv_replicate"]`.
# The other two are downstream of the same branch: the singleton reaches the
# empty case on the way down, and the shortest run of copies is the empty list,
# so the base of the inductive law is this branch too.
import Base
import ./prelude.bend as P

def count_inv(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> +t:
      P.count_gt(h, t) + count_inv(t)
