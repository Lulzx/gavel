import Base
import ./prelude.bend as P

# The element is added raw: `P.succ2` is never called, so the body is the plain
# sum. `sum_succ2_nil` holds -- an empty list still adds nothing -- and
# `sum_succ2_snoc` rejects it: at an appended `x = 3n` the law's right-hand side
# gains `P.succ2(3n)`, which is `5n`, where the body's answer gains `3n`.
def sum_succ2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_succ2(t)
