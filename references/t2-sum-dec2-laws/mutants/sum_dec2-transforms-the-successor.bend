import Base
import ./prelude.bend as P

# An off-by-one on the element: each head is stepped back one place too far
# before `P.dec2` is applied. `sum_dec2_nil` holds -- no head is reached there --
# and `sum_dec2_snoc` rejects it: at an appended `x = 2n` the law's right-hand
# side gains `P.dec2(2n)`, which is `0n`, where the body's answer gains
# `P.dec2(1n + 2n)`, which is `1n`.
def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.dec2(1n + h) + sum_dec2(t)
