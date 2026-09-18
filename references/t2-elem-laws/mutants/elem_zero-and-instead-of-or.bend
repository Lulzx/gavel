import Base
import ./prelude.bend as P

# `and` in place of `or`: the fold's shape with the wrong connective, which a
# person can reach by thinking of the elements as all having to be zero.
# Rejected by `elem_zero_snoc`: at the empty `xs` the law's left-hand side is
# the stuck `and(is_zero_b(x), False{})` where its right-hand side is
# `is_zero_b(x)`. `elem_zero_nil` holds -- `and(is_zero_b(h), False{})` reduces
# to `False{}` whatever the head is -- so the law that reaches the cons cells is
# the one that rejects this body.
def elem_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_zero_b(h), elem_zero(t))
