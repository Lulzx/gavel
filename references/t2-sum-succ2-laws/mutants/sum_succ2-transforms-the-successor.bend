import Base
import ./prelude.bend as P

# An off-by-one on the element: each head is stepped forward before `P.succ2` is
# applied. `sum_succ2_nil` holds -- no head is reached there -- and
# `sum_succ2_snoc` rejects it: at an appended `x = 0n` the law's right-hand side
# gains `P.succ2(0n)`, which is `2n`, where the body's answer gains
# `P.succ2(1n + 0n)`, which is `3n`.
def sum_succ2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.succ2(1n + h) + sum_succ2(t)
