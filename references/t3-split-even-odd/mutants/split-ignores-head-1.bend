import Base
import ./prelude.bend as P

# Splits the tail and never places the head in either half: the elements that
# are kept are alternated correctly, one is simply missing. The base case is the
# reference's, so `split_nil` holds, and `split_cons` rejects it -- its right
# side puts `h` on the front of the odd half and this computes to the bare
# `S.split(t)`. The length law fails too, since the halves are one short.
def split(+xs: List<&2, Nat>) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      split(t)
