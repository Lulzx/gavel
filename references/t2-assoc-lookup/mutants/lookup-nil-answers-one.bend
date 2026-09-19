import Base
import ./prelude.bend as P

# `assoc_lookup` answers `1n` at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `lookup_nil`.
def assoc_lookup(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  match kvs:
    case Nil{}:
      1n
    case P.Mk{hk, hv} <> t:
      P.key_select(hk, k, hv, assoc_lookup(t, k))
