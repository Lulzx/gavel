import Base
import ./prelude.bend as P

# The empty list is answered with `1n`. `sum_pow2_nil` rejects it -- the law
# wants `0n` and the body answers `1n` -- and so does `sum_pow2_snoc`, whose base
# case is the same empty list.
def sum_pow2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.pow2(h) + sum_pow2(t)
