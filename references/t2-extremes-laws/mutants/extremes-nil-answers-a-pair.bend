import Base
import ./prelude.bend as P

# `extremes` answers a two-element list on the empty input.
#
# This file exists for a law that no generated mutant fails: `extremes_nil`'s
# left-hand side is the ground term `extremes(Nil{})`, so the match has already
# stopped and there is no step for a rule-based rewrite to change. It is the
# reference with that one case given a non-empty answer, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `extremes_nil`.
def ext_go(xs: List<&2, Nat>, lo: Nat, hi: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      lo <> hi <> Nil{}
    case +h <> t:
      ext_go(t, P.min2(h, lo), P.max2(h, hi))

def extremes(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> 0n <> Nil{}
    case +h <> t:
      ext_go(t, h, h)
