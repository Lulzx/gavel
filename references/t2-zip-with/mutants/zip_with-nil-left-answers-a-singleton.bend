import Base
import ./prelude.bend as P

# `zip_with` answers `0n <> Nil{}` -- a one-element list -- when the first list
# is empty.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generated corpus rewrites a *step*, and the empty first list is an answer
# reached by a match that has already stopped, so nothing generated for this
# task can touch it. It is the reference with the outer empty case given a
# non-empty answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `zip_with_len`, `zip_with_nil_left`, `zip_with_nil_right`, `zip_with_self`.
def zip_with(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          P.max(h1, h2) <> zip_with(t1, t2)
