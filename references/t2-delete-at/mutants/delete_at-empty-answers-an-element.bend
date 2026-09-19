import Base
import ./prelude.bend as P

# `delete_at` answers a one-element list when the list is empty.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the empty case's answer changed, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `delete_at_nil`, `delete_at_take_drop`.
def delete_at(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          1n <> Nil{}
        case h <> t:
          t
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> delete_at(p, t)
