import Base
import ./prelude.bend as P

# The element is added raw: `P.sq_inc` is never called, so the body is the plain
# sum. `sum_sq_inc_nil` holds -- an empty list still adds nothing -- and
# `sum_sq_inc_snoc` rejects it: at an appended `x = 3n` the law's right-hand side
# gains `P.sq_inc(3n)`, which is `10n`, where the body's answer gains `3n`.
def sum_sq_inc(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_sq_inc(t)
