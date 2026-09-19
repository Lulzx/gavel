import Base
import ./prelude.bend as P

# `replace_at` *inserts* `y` at position `0n` instead of replacing the head, so
# the list comes back one element longer.
#
# This file exists for a law that no generated mutant fails: the `0n` arm is an
# answer a match that has already stopped gives, so no step rewrite reaches it.
# This is the reference with that one case given a different answer, so it
# type-checks and every recursive call is untouched.
#
# Measured against this task's law set: tier 3, failing `replace_at_zero`
# (`y <> h <> t` where `y <> t` was expected) and `replace_at_idem`.
def replace_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          y <> h <> t
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> replace_at(p, t, y)
