import Base
import ./prelude.bend as P

# `pairs` answers a pair on a one-element input.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `pairs_len`, `pairs_single`.
def pairs(xs: List<Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case +x <> t:
      match t:
        case Nil{}:
          P.MkPair{x, x} <> Nil{}
        case +h <> t2:
          P.MkPair{x, h} <> pairs(h <> t2)
