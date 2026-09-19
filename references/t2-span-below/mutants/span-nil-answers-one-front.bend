import Base
import ./prelude.bend as P

# `span_below` answers a one-element front at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `span_below_len`, `span_below_nil`.
def span_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{1n <> Nil{}, Nil{}}
    case h <> t:
      P.span_put(h, t, span_below(t, n), P.le(h, n))
