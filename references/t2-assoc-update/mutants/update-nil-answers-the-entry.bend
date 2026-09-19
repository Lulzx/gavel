import Base
import ./prelude.bend as P

# `assoc_update` answers the new entry on an empty map.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `update_nil`.
def assoc_update(kvs: List<&2, P.Entry>, +k: Nat, +v: Nat) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      P.Mk{k, v} <> Nil{}
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, P.Mk{k, v} <> t, P.Mk{hk, hv} <> assoc_update(t, k, v))
