import Base
import ./prelude.bend as P

# A body a person would plausibly write: the empty list answered with `True{}`,
# as if the existence claim were the vacuous one and the universal one the real
# claim. Rejected by `elem_zero_nil`, which is definitional -- the body reduces
# the left-hand side to `True{}` where the law wants `False{}` -- and by
# `elem_zero_snoc` as well: at the empty `xs` the law's left-hand side is the
# stuck `or(is_zero_b(x), True{})` while its right-hand side is
# `or(elem_zero(Nil{}), is_zero_b(x))`, which reduces to `True{}` on its own.
def elem_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_zero_b(h), elem_zero(t))
