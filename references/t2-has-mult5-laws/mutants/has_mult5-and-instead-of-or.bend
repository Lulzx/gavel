import Base
import ./prelude.bend as P

# `and` in place of `or`: the fold's shape with the wrong connective, which a
# person can reach by thinking of the elements as all having to be multiples of
# five. Rejected by `has_mult5_snoc`: at the empty `xs` the law's left-hand side
# is the stuck `and(is_mult5_b(x), False{})` where its right-hand side is
# `is_mult5_b(x)`. `has_mult5_nil` holds -- `and(is_mult5_b(h), False{})`
# reduces to `False{}` whatever the head is -- so the law that reaches the cons
# cells is the one that rejects this body.
def has_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_mult5_b(h), has_mult5(t))
