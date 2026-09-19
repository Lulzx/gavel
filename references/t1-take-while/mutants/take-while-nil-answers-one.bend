import Base
import ./prelude.bend as P

# `take_while` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `take_while_nil`.
def take_while(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case +h <> t:
      P.keep_put(h, take_while(t, n), P.le(h, n))
