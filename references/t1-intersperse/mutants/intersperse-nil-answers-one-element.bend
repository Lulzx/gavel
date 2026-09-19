import Base
import ./prelude.bend as P

# `intersperse` answers one element at `Nil{}`.
#
# This file exists for a law that no generated mutant in the corpus fails:
# `intersperse_nil` is a pin on the empty input, and the generator rewrites
# recursive steps rather than literal answers, so every type-checking mutant it
# produced leaves the empty case alone and the pin had no killer. It is the
# reference with the empty case given a non-empty answer, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `intersperse_nil` and `intersperse_len`.
def intersperse(xs: List<&2, Nat>, +sep: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      match t:
        case Nil{}:
          h <> Nil{}
        case h2 <> t2:
          h <> (sep <> intersperse(t, sep))
