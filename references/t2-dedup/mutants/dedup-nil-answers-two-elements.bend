import Base
import ./prelude.bend as P

# `dedup` answers two elements at `Nil{}`.
#
# This file exists for a law that no generated mutant in the corpus fails:
# every type-checking mutant the generator produced leaves the empty case alone,
# so `dedup_nil` had no killer at all. It is the reference with the empty case
# given a non-empty answer, so it type-checks and every recursive step is
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `dedup_nil`.
def dedup(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> (0n <> Nil{})
    case +h <> t:
      match t:
        case Nil{}:
          h <> Nil{}
        case +h2 <> t2:
          P.same_put(h, dedup(h2 <> t2), P.same(h, h2))
