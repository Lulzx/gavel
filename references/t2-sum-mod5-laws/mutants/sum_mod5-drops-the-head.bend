import Base
import ./prelude.bend as P

# The step walks the tail without adding the head, so only the elements the
# recursion skipped are counted. `sum_mod5_nil` holds -- the empty list still
# adds nothing -- and `sum_mod5_snoc` rejects it: at an appended `x = 3n` the
# law's right-hand side gains `P.mod5(3n)`, which is `3n`, where the body's
# answer gains nothing.
def sum_mod5(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_mod5(t)
