import Base
import ./prelude.bend as P

# The mirror slip: the recursion is there and the head's test is not, so the
# fold looks past the element in front of it. Rejected by `has_one_snoc`, twice
# over. At the empty `xs` the law's left-hand side reduces to `False{}` while
# its right-hand side is `is_one_b(x)`, and at the cons step the left-hand side
# is `or(has_one(t), is_one_b(x))` where the right-hand side has the head's test
# or-ed in as well.
def has_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      has_one(t)
