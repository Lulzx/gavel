import Base
import ./prelude.bend as P

# `take_every_nth` answers one cell for a stride of `0n`.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and the `0n` case of `take_every_nth` is an
# answer reached by a match that has already stopped. It is the reference with
# that one case given a non-empty answer, so it type-checks and every recursive
# step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `take_every_nth_zero`, `take_every_nth_nil`.
def every_nth_go(xs: List<&2, Nat>, +m: Nat, i: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> +t:
      match i:
        case 0n:
          h <> every_nth_go(t, m, m)
        case 1n+q:
          every_nth_go(t, m, q)

def take_every_nth(n: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      1n <> Nil{}
    case 1n+p:
      every_nth_go(xs, p, 0n)
