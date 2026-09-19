import Base
import ./prelude.bend as P

# The product of no rows answers one cell.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and `cross`'s `Nil{}` case is an answer reached
# by a match that has already stopped. It is the reference with that one case
# given a cell, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `cross_nil`,
# `cross_one`, `cross_two_two`. The two content laws see it because the empty
# product is the tail they append nothing to.
def row(+x: Nat, ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      Nil{}
    case y <> t:
      P.MkPair{x, y} <> row(x, t)

def cross(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      P.MkPair{0n, 0n} <> Nil{}
    case x <> t:
      P.append(row(x, ys), cross(t, ys))
