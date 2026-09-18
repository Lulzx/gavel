import Base
import ./prelude.bend as P

# An off-by-one on the element: each head is stepped forward before `P.sq_inc`
# is applied. `sum_sq_inc_nil` holds -- no head is reached there -- and
# `sum_sq_inc_snoc` rejects it: at an appended `x = 0n` the law's right-hand side
# gains `P.sq_inc(0n)`, which is `1n`, where the body's answer gains
# `P.sq_inc(1n + 0n)`, which is `2n`.
def sum_sq_inc(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.sq_inc(1n + h) + sum_sq_inc(t)
