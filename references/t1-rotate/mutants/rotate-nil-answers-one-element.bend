import Base
import ./prelude.bend as P

# `rotate` answers one element at `Nil{}`.
#
# This file exists for a law that no generated mutant in the corpus fails:
# `rotate_nil` is a pin on the empty list, and the generator rewrites recursive
# steps rather than literal answers, so every type-checking mutant it produced
# leaves the inner empty case alone and the pin had no killer. It is the
# reference with that case given a one-element answer, so it type-checks and
# every non-empty input is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `rotate_nil`.
def rotate(n: Nat, +xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      match xs:
        case Nil{}:
          0n <> Nil{}
        case h <> t:
          rotate(p, P.append(t, h <> Nil{}))
