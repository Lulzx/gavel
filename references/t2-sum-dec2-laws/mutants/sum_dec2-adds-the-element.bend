import Base
import ./prelude.bend as P

# The element is added raw: `P.dec2` is never called, so the body is the plain
# sum. `sum_dec2_nil` holds -- an empty list still adds nothing -- and
# `sum_dec2_snoc` rejects it: at an appended `x = 5n` the law's right-hand side
# gains `P.dec2(5n)`, which is `3n`, where the body's answer gains `5n`.
def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_dec2(t)
