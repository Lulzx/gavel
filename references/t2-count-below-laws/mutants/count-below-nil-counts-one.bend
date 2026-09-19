import Base
import ./prelude.bend as P

# `count_below` counts one element in an empty list.
#
# This file exists for a law that no generated mutant fails: `count_below_nil`'s
# left-hand side is the ground term `count_below(x, Nil{})`, so the match has
# already stopped and there is no step for a rule-based rewrite to change. It is
# the reference with that one case given a non-zero answer, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `count_below_nil`, `count_below_split`.
def count_below(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.cb_put(count_below(x, t), P.le(h, x))

def count_above(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.ca_put(count_above(x, t), P.le(h, x))
