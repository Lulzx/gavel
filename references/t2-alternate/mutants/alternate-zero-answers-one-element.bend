import Base
import ./prelude.bend as P

# `alternate` answers one element when there is nothing left to alternate.
#
# This file exists for a law that no other mutant in the corpus fails: the
# empty case is an answer reached by a match that has already stopped, so the
# generator's rewrites never touch it. It is the reference with that answer
# given a non-empty list, so it type-checks and every recursive step is
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `alternate_zero`, `alternate_two`, `alternate_len`.
def alternate(n: Nat, +a: Nat, +b: Nat) -> List<Nat>:
  match n:
    case 0n:
      a <> Nil{}
    case 1n+p:
      a <> alternate(p, b, a)
