import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The reference
# with the decision reversed: `P.is_eq(h, h2)` adds one at a *continuation* and
# nothing at a boundary, where the reference adds nothing at a continuation and
# one at a boundary. It is the body `count_runs_diff`'s own comment names as the
# one that "agrees with every law above and is separated here", so measuring it
# checks that claim rather than restating it.
#
# Measured 2026-09-19: tier 3, laws_failed [count_runs_same, count_runs_diff].

def count_runs(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match t:
        case Nil{}:
          1n
        case +h2 <> t2:
          P.is_eq(h, h2) + count_runs(h2 <> t2)
