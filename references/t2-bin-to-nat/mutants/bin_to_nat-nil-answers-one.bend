# `bin_to_nat` answers one for the empty list.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `bin_to_nat_cons` and failing `bin_to_nat_nil`, `bin_to_nat_nat_bits`.
import Base
import ./prelude.bend as P

def bin_to_nat(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      1n
    case h <> t:
      h + 2n * bin_to_nat(t)
