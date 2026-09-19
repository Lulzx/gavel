import Base
import ./prelude.bend as P

# The walk recurses with a seen set holding nothing but the element just kept,
# so each element is compared with the one before it rather than with everything
# before it. This is the adjacent-only body: the answer on `[1n, 2n, 1n]` is the
# whole list back, and a duplicate far from its twin survives.
#
# This file exists for `distinct_nonadjacent`, whose left-hand side is a ground
# term -- a list whose duplicate is not adjacent. It is a one-token change from
# the reference -- `h <> Nil{}` in place of `h <> seen` -- so it type-checks and
# every other call is untouched.
#
# Measured against this task's law set: tier 3, failing `distinct_go_step`,
# `distinct_same_seen`, `distinct_same` and `distinct_nonadjacent`.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> Nil{}))

def distinct(xs: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> distinct_go(t, h <> Nil{})
