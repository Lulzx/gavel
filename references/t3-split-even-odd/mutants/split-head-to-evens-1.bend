import Base
import ./prelude.bend as P

# Alternates the two halves the other way round: the head joins the even half
# instead of the odd one. Both halves keep every other element and between them
# they still hold the whole list, so the count is exactly right and the length
# law is *true* of this body -- the reference induction still fails against it,
# because it is arranged around the other alternation. `split_cons` is the law
# that rejects it outright, wanting `P.MkL{h <> P.odds(S.split(t)), P.evens(S.split(t))}`
# where this computes to `P.MkL{h <> P.evens(S.split(t)), P.odds(S.split(t))}`.
def split(+xs: List<&2, Nat>) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.MkL{h <> P.evens(split(t)), P.odds(split(t))}
