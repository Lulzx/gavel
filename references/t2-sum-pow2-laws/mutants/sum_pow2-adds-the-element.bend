import Base
import ./prelude.bend as P

# The element is added raw: `P.pow2` is never called, so the body is the plain
# sum. `sum_pow2_nil` holds -- an empty list still adds nothing -- and
# `sum_pow2_snoc` rejects it: at an appended `x = 3n` the law's right-hand side
# gains `P.pow2(3n)`, which is `8n`, where the body's answer gains `3n`.
def sum_pow2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_pow2(t)
