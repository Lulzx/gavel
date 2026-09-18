import Base
import ./prelude.bend as P

# The step walks the tail without adding the head, so the answer counts only the
# elements the recursion skipped. `sum_dec2_nil` holds -- the empty list still
# adds nothing -- and `sum_dec2_snoc` rejects it: at an appended `x = 3n` the
# law's right-hand side gains `P.dec2(3n)`, which is `1n`, where the body's
# answer gains nothing.
def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_dec2(t)
