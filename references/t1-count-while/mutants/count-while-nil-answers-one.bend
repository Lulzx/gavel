import Base
import ./prelude.bend as P

# `count_while` answers `1n` at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `count_while_nil`.
def count_while(xs: List<Nat>, +n: Nat) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.count_put(count_while(t, n), P.le(h, n))
