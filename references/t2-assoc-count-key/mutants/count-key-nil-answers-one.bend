import Base
import ./prelude.bend as P

# `count_key` answers `1n` at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `count_key_nil`.
def count_key(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  match kvs:
    case Nil{}:
      1n
    case P.Mk{hk, hv} <> +t:
      P.key_select(hk, k, 1n + count_key(t, k), count_key(t, k))
