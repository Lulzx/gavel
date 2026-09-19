import Base
import ./prelude.bend as P

# A row over an empty second list answers one cell.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and `row`'s `Nil{}` case is an answer reached by
# a match that has already stopped. It is the reference with that one case given
# a cell, so it type-checks and every recursive step is untouched. No law that
# hands `row` a variable `ys` can see it -- both sides of those call the same
# function -- and the closed law sees it only at the far end of a row, where the
# walk reaches the empty list after the cells are already built.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `row_nil`,
# `cross_two_two`.
def row(+x: Nat, ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      P.MkPair{x, 0n} <> Nil{}
    case y <> t:
      P.MkPair{x, y} <> row(x, t)

def cross(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      P.append(row(x, ys), cross(t, ys))
