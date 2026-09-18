import Base
import ./prelude.bend as P

# The empty list is answered with `1n`, which is also the value `P.sq_inc`
# gives to `0n`, so the base case looks like a head was added. `sum_sq_inc_nil`
# rejects it -- the law wants `0n` and the body answers `1n` -- and so does
# `sum_sq_inc_snoc`, whose base case is the same empty list.
def sum_sq_inc(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.sq_inc(h) + sum_sq_inc(t)
