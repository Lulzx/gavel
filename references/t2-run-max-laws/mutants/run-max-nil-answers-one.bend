import Base
import ./prelude.bend as P

# `run_max` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 2,
# failing `run_max_append`, `run_max_nil`, `run_max_single`.
def run_max(xs: List<Nat>, +m: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> t:
      P.max(m, h) <> run_max(t, P.max(m, h))
