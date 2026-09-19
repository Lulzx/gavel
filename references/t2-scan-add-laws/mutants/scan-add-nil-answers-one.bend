import Base
import ./prelude.bend as P

# `scan_add` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 2,
# failing `scan_add_append`, `scan_add_nil`, `scan_add_single`.
def scan_add(xs: List<Nat>, +acc: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> t:
      (acc + h) <> scan_add(t, acc + h)
