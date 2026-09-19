import Base
import ./prelude.bend as P

# The walk answers a one-element list when it runs out of elements, so one
# arbitrary number is appended to every answer that reaches the end of the walk
# -- a duplicate of the first element is enough, since the walk always ends.
#
# This file exists for a law that no generated mutant fails: the generated
# mutants that type-check rewrite the walk's step, and this law is about the
# walk's empty arm. This is the reference with that arm given a different
# answer, so it type-checks and every recursive call is untouched.
#
# Measured against this task's law set: tier 3, failing `distinct_go_nil`,
# `distinct_same_seen`, `distinct_same` and `distinct_nonadjacent`.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> t:
      P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> seen))

def distinct(xs: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> distinct_go(t, h <> Nil{})
