import Base
import ./prelude.bend as P

# The empty list is answered with `1n`. `sum_succ2_nil` rejects it -- the law
# wants `0n` and the body answers `1n` -- and so does `sum_succ2_snoc`, whose
# base case is the same empty list.
def sum_succ2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.succ2(h) + sum_succ2(t)
