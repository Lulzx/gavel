import Base
import ./prelude.bend as P

# An off-by-one on the element: each head is stepped forward before `P.pow2` is
# applied, which doubles its contribution. `sum_pow2_nil` holds -- no head is
# reached there -- and `sum_pow2_snoc` rejects it: at an appended `x = 0n` the
# law's right-hand side gains `P.pow2(0n)`, which is `1n`, where the body's
# answer gains `P.pow2(1n + 0n)`, which is `2n`.
def sum_pow2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.pow2(1n + h) + sum_pow2(t)
