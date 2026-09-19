import Base
import ./prelude.bend as P

# `insert_at` drops the element when the position is zero.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the stopped match's answer left as the list itself, so it
# type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `insert_at_zero`, `insert_at_take_drop`.
def insert_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      match xs:
        case Nil{}:
          y <> Nil{}
        case h <> t:
          h <> insert_at(p, t, y)
