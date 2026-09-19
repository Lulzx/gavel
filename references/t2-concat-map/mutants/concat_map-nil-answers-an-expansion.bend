import Base
import ./prelude.bend as P

# `concat_map` answers one expansion on the empty list instead of `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generated corpus rewrites a *step*, and the empty list is an answer reached by
# a match that has already stopped, so nothing generated for this task can touch
# it. It is the reference with the empty case given a non-empty answer, so it
# type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `concat_map_concat`, `concat_map_len`, `concat_map_nil`.
def concat_map(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.expand(0n)
    case h <> t:
      P.append(P.expand(h), concat_map(t))
