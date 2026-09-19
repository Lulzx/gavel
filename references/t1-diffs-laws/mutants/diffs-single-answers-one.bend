import Base
import ./prelude.bend as P

# `diffs` answers a one-element list on a one-element input.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `diffs_len`, `diffs_single`.
def diffs(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          1n <> Nil{}
        case +h2 <> t2:
          P.sub(h2, h) <> diffs(h2 <> t2)
