import Base
import ./prelude.bend as P

# `index_of` answers `1n` on the empty list instead of `0n`.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generated corpus rewrites a *step*, and the empty list is an answer reached by
# a match that has already stopped, so nothing generated for this task can touch
# it. It is the reference with the empty case given a different answer, so it
# type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `index_of_miss`, `index_of_nil`.
def index_of(xs: List<Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.at_if(P.eq(h, k), 0n, 1n + index_of(t, k))
