import Base
import ./prelude.bend as P

# `insert_at` drops the element when the position is past the end of the list.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the second stopped match's answer left as the empty list,
# so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `insert_at_nil`, `insert_at_take_drop`.
def insert_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      y <> xs
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> insert_at(p, t, y)
