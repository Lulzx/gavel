import Base
import ./prelude.bend as P

# `enum_from` answers a one-element run at a count of zero.
#
# This file exists for the empty case, which no generated mutant reaches: the
# generator rewrites a step, and `0n` is an answer reached by a match that has
# already stopped. It is the reference with the `0n` case given a non-empty
# answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `enum_from_zero`, `enum_from_len`.
def enum_from(n: Nat, +a: Nat) -> List<Nat>:
  match n:
    case 0n:
      a <> Nil{}
    case 1n+j:
      a <> enum_from(j, 1n + a)
