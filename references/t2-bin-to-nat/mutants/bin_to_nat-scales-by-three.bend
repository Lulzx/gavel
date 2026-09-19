# `bin_to_nat` gives the tail weight three rather than two.
#
# The recursion is the reference's at every construct; it is the scaling of a
# bit's position that is wrong. It type-checks, and it is the law that says a
# position is worth twice its neighbour that catches it.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `bin_to_nat_nil` and failing `bin_to_nat_cons`, `bin_to_nat_nat_bits`.
import Base
import ./prelude.bend as P

def bin_to_nat(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      0n
    case h <> t:
      h + 3n * bin_to_nat(t)
