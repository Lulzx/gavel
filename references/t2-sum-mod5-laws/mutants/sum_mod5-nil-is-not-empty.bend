import Base
import ./prelude.bend as P

# The empty list is answered with `1n`. `sum_mod5_nil` rejects it -- the law
# wants `0n` and the body answers `1n` -- and so does `sum_mod5_snoc`, whose base
# case is the same empty list.
def sum_mod5(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.mod5(h) + sum_mod5(t)
