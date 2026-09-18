import Base

# The same sum in the other order: the tail is added to the head rather than the
# head to the tail. Addition on `Nat` is commutative, so this body answers the
# same number as the reference on every input -- and `sum_cons` is stated as
# `{==}` against `h + S.sum(t)`, where the two sides are stuck on a variable
# each, so the law is what tells the two orders apart. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sum_cons`.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum(t) + h
