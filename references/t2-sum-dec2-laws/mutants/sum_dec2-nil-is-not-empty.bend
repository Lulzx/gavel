import Base
import ./prelude.bend as P

# The empty list is answered with `1n`, the "never hand back nothing" slip.
# `sum_dec2_nil` rejects it -- the law wants `0n` and the body answers `1n` --
# and so does `sum_dec2_snoc`, whose base case is the same empty list.
def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.dec2(h) + sum_dec2(t)
