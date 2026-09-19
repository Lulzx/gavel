import Base
import ./prelude.bend as P

# `zip3` answers a one-element list with a `Nil{}` third argument.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `zip3_len`, `zip3_nil_right`.
def zip3(xs: List<Nat>, ys: List<Nat>, zs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          match zs:
            case Nil{}:
              0n <> Nil{}
            case h3 <> t3:
              (h1 + h2 + h3) <> zip3(t1, t2, t3)
