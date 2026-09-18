import Base
import ./prelude.bend as P

# The step walks the tail without adding the head, so the answer counts only the
# elements the recursion skipped. `sum_sq_inc_nil` holds -- the empty list still
# adds nothing -- and `sum_sq_inc_snoc` rejects it: at an appended `x = 0n` the
# law's right-hand side gains `P.sq_inc(0n)`, which is `1n`, where the body's
# answer gains nothing.
def sum_sq_inc(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_sq_inc(t)
