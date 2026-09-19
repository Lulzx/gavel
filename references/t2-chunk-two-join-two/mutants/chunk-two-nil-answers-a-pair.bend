import Base
import ./prelude.bend as P

# `chunk_two` answers a pair at `Nil{}`.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `chunk_two_join_two`, `chunk_two_nil`.
def chunk_two(xs: List<Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      P.MkPair{0n, 0n} <> Nil{}
    case x <> t:
      match t:
        case Nil{}:
          Nil{}
        case h <> t2:
          P.MkPair{x, h} <> chunk_two(t2)

def join_two(ps: List<&2, P.Pair>) -> List<Nat>:
  match ps:
    case Nil{}:
      Nil{}
    case P.MkPair{a, b} <> t:
      a <> (b <> join_two(t))
