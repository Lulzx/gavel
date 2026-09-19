import Base
import ./prelude.bend as P

# `join_two` answers a one-element list at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `join_two_nil`.
def chunk_two(xs: List<Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      match t:
        case Nil{}:
          Nil{}
        case h <> t2:
          P.MkPair{x, h} <> chunk_two(t2)

def join_two(ps: List<&2, P.Pair>) -> List<Nat>:
  match ps:
    case Nil{}:
      0n <> Nil{}
    case P.MkPair{a, b} <> t:
      a <> (b <> join_two(t))
