import Base
import ./prelude.bend as P

# `keys` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `keys_len`, `keys_nil`.
def assoc_put(kvs: List<&2, P.Entry>, k: Nat, v: Nat) -> List<&2, P.Entry>:
  P.Mk{k, v} <> kvs

def keys(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  match kvs:
    case Nil{}:
      1n <> Nil{}
    case P.Mk{hk, hv} <> t:
      hk <> keys(t)
