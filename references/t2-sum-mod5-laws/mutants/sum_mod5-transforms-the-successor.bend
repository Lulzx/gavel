import Base
import ./prelude.bend as P

# An off-by-one on the element: each head is stepped forward before `P.mod5` is
# applied, so a multiple of five enters the sum as `0n`. `sum_mod5_nil` holds --
# no head is reached there -- and `sum_mod5_snoc` rejects it: at an appended
# `x = 4n` the law's right-hand side gains `P.mod5(4n)`, which is `4n`, where the
# body's answer gains `P.mod5(1n + 4n)`, which is `0n`.
def sum_mod5(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.mod5(1n + h) + sum_mod5(t)
