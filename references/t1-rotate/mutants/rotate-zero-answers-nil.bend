import Base
import ./prelude.bend as P

# `rotate` answers `Nil{}` at `0n`.
#
# This file exists for a law that no generated mutant in the corpus fails:
# `rotate_zero` is a pin on the input where nothing is rotated, and the
# generator rewrites recursive steps rather than literal answers, so every
# type-checking mutant it produced leaves the `0n` case alone and the pin had no
# killer. It is the reference with the `0n` case answered by `Nil{}` instead of
# by the list, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `rotate_zero`.
def rotate(n: Nat, +xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          rotate(p, P.append(t, h <> Nil{}))
