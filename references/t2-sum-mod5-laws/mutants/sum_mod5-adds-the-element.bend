import Base
import ./prelude.bend as P

# The element is added raw: `P.mod5` is never called, so the body is the plain
# sum. `sum_mod5_nil` holds -- an empty list still adds nothing -- and
# `sum_mod5_snoc` rejects it: at an appended `x = 6n` the law's right-hand side
# gains `P.mod5(6n)`, which is `1n`, where the body's answer gains `6n`.
def sum_mod5(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum_mod5(t)
