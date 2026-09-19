import Base
import ./prelude.bend as P

# `count_up` answers a one-element list at `0n`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `count_up_rev_count_down`, `count_up_zero`, `len_count_up`.
def count_up(n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      1n <> Nil{}
    case 1n++k:
      P.snoc(count_up(k), k)

def count_down(n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n++k:
      k <> count_down(k)
