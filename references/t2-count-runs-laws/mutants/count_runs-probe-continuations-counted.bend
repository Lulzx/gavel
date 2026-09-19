# PROBE (2026-09-19, tag f1): the candidate wrong body that seemed most likely to
# escape this law set. It is the reference with the step's arithmetic replaced by
# the decision itself -- boundaries counted as continuations and continuations as
# boundaries -- which is the shape a thin law set over a branch-free step would
# miss, because `count_runs_diff` and `count_runs_same` are the only two laws
# that look at the step and neither is definitional.
#
# Measured 2026-09-19, same command as the other hand mutant: **tier 3**,
# `laws_failed = ["count_runs_same", "count_runs_diff"]`. The set is sound
# against it: both step laws catch it, and neither is a shape rejection -- they
# are the laws the body disobeys.
import Base
import ./prelude.bend as P

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
