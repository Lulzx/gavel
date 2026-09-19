import Base
import ./prelude.bend as P

# `delete_at` answers the whole list at a count of `0n` instead of the tail.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the stopped match's answer changed, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `delete_at_zero`, `delete_at_take_drop`.
def delete_at(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case +h <> t:
          h <> t
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> delete_at(p, t)
