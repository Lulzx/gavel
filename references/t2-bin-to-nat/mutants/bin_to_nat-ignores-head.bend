# `bin_to_nat` drops the head of every cons cell.
#
# The recursion is the reference's and the empty case is the reference's; only
# the face value of the low bit is lost. It type-checks, and it is the law that
# says a bit contributes its own value that catches it.
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
      2n * bin_to_nat(t)
