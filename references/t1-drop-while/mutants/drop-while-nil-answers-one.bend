import Base
import ./prelude.bend as P

# `drop_while` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `drop_while_nil`.
def drop_while(+xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.drop_put(h, t, drop_while(t, n), P.le(h, n))
