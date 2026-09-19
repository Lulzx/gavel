import Base
import ./prelude.bend as P

# A row pairs each element of `ys` with `x` the wrong way round.
#
# This is the hand-written mutant the ground law needs: `cross_two_two` names
# every cell of a closed product, and it is the law that reads the *pair* rather
# than the list around it. The generated corpus reaches the same cell list in a
# different order; this one reaches the same order with the two halves of each
# pair swapped, which no reordering of a row or a product can produce. The
# recursive step still moves along `ys`, so it type-checks.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `row_cons`,
# `cross_two_two`.
def row(+x: Nat, ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      Nil{}
    case y <> t:
      P.MkPair{y, x} <> row(x, t)

def cross(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      P.append(row(x, ys), cross(t, ys))
