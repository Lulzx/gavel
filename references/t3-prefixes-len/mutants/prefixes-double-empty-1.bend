import Base
import ./prelude.bend as P

# Puts the empty list at the front of the enumeration twice. The list itself
# type-checks and every element of it is a prefix, so nothing about the elements
# is wrong -- what is wrong is how many there are, one too many at every step.
# `prefixes_cons` rejects it on the shape of the first constructor, and
# `prefixes_len` rejects it too, since the count is one more than the law's.
def prefixes(xs: List<&2, Nat>) -> P.Prefixes:
  match xs:
    case Nil{}:
      P.PCons{Nil{}, P.PNil{}}
    case h <> t:
      P.PCons{Nil{}, P.PCons{Nil{}, P.cons_all(h, prefixes(t))}}
