import Base
import ./prelude.bend as P

# `distinct` answers a one-element list on the empty input instead of the empty
# list, so a caller handed no elements gets a list with one arbitrary number in
# it. Every other input is untouched: the rest of the walk never reaches this
# arm, because the arm is taken on `Nil{}` alone.
#
# This file exists for a law that no generated mutant fails: `distinct_nil`'s
# left-hand side is the ground term `Nil{}`, so the generator -- whose mutants
# rewrite a step or swap case bodies -- never states a body that changes only
# this arm. This is the reference with the empty arm given a different answer.
#
# Measured against this task's law set: tier 3, failing `distinct_nil`.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> seen))

def distinct(xs: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> t:
      h <> distinct_go(t, h <> Nil{})
