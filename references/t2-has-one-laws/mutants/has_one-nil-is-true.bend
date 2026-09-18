import Base
import ./prelude.bend as P

# A body a person would plausibly write: the empty list answered with `True{}`,
# as if the existence claim were the vacuous one and the universal one the real
# claim. Rejected by `has_one_nil`, which is definitional -- the body reduces
# the left-hand side to `True{}` where the law wants `False{}` -- and by
# `has_one_snoc` as well: at the empty `xs` the law's left-hand side is the
# stuck `or(is_one_b(x), True{})` while its right-hand side is
# `or(has_one(Nil{}), is_one_b(x))`, which reduces to `True{}` on its own.
def has_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_one_b(h), has_one(t))
