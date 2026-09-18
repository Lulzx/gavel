import Base
import ./prelude.bend as P

# Carries the head across every prefix correctly and drops the empty list from
# the front of the enumeration. Every prefix of the list is still there, in
# order, one element short at the front -- which is exactly what the length law
# measures, so `prefixes_len` rejects it as well. `prefixes_cons` is the law that
# names the missing list, wanting `P.PCons{Nil{}, ...}` where this computes to
# the bare `P.cons_all(...)`.
def prefixes(xs: List<&2, Nat>) -> P.Prefixes:
  match xs:
    case Nil{}:
      P.PCons{Nil{}, P.PNil{}}
    case h <> t:
      P.cons_all(h, prefixes(t))
