import Base
import ./prelude.bend as P

# The empty list has no prefixes at all rather than one. The recursive branch is
# the reference's, so `prefixes_cons` holds, and `prefixes_nil` is the law that
# fixes where the enumeration starts: it rejects `P.PNil{}` against
# `P.PCons{Nil{}, P.PNil{}}`.
def prefixes(xs: List<&2, Nat>) -> P.Prefixes:
  match xs:
    case Nil{}:
      P.PNil{}
    case h <> t:
      P.PCons{Nil{}, P.cons_all(h, prefixes(t))}
