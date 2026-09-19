import Base
import ./prelude.bend as P

# `sec_go` answers its *first* running value on the empty list instead of its
# second.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step, and the walk's empty case is
# an answer a match that has already stopped gives -- it never recurses, so no
# step rewrite reaches it, and `sec_go_nil` was killed only by corpus entries
# that fail to type-check. This is the reference with that one case given the
# other running value, so it type-checks and every recursive call is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `sec_go_nil`,
# `second_max_three`.
def sec_go(xs: List<&2, Nat>, +top: Nat, second: Nat) -> Nat:
  match xs:
    case Nil{}:
      top
    case +h <> t:
      sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second))

def second_max(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sec_go(t, h, 0n)
