import Base
import ./prelude.bend as P

# `second_max` answers `1n` for the empty list instead of `0n`.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step or a cons case, and the empty
# input is an answer a match that has already stopped gives -- `second_max(Nil{})`
# never reaches the walk, so no step rewrite changes it. This is the reference
# with that one case given a non-empty answer, so it type-checks and every
# recursive call is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `second_max_nil`.
def sec_go(xs: List<&2, Nat>, +top: Nat, second: Nat) -> Nat:
  match xs:
    case Nil{}:
      second
    case +h <> t:
      sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second))

def second_max(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      sec_go(t, h, 0n)
