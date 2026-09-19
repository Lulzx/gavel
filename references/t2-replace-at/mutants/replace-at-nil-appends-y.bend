import Base
import ./prelude.bend as P

# `replace_at` puts `y` on the end when the count runs past the list, instead of
# leaving the list alone.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a step or swap case bodies, and the
# out-of-range arm is an answer a match that has already stopped gives -- it
# recurses no further, so no step rewrite reaches it. This is the reference with
# that one case given a non-empty answer, so it type-checks and every recursive
# call is untouched.
#
# Measured against this task's law set: tier 3, failing `replace_at_nil`
# (`[y]` where `[]` was expected) and `replace_at_idem`.
def replace_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          y <> t
    case 1n+p:
      match xs:
        case Nil{}:
          y <> Nil{}
        case h <> t:
          h <> replace_at(p, t, y)
