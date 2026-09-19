import Base
import ./prelude.bend as P

# TODO(policy): implement. `pairs(xs)` packs each element of `xs` with the one
# after it, left to right, and drops a last element that has no neighbour: the
# result is a list of the prelude's pairs, built with `P.MkPair{a, b}`. One
# element or none gives `Nil{}`.
def pairs(xs: List<Nat>) -> List<&2, P.Pair>:
  ?TODO
