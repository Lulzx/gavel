import Base
import ./prelude.bend as P

# `sum_values` answers `1n` at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `sum_values_nil`, `sum_values_values`.
def values(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{hk, hv} <> t:
      hv <> values(t)

def sum_values(kvs: List<&2, P.Entry>) -> Nat:
  match kvs:
    case Nil{}:
      1n
    case P.Mk{hk, hv} <> t:
      hv + sum_values(t)
