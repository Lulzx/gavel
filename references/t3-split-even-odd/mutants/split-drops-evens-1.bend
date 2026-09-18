import Base
import ./prelude.bend as P

# Builds the odd half and leaves the even one empty. Every element that survives
# is in the right half in the right order, so the shape of the answer is right
# and half of it is missing -- which is what the length law measures. The step
# law is the one that names the missing half: `split_cons` wants
# `P.evens(S.split(t))` as the second component and this computes to `Nil{}`.
def split(+xs: List<&2, Nat>) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.MkL{h <> P.odds(split(t)), Nil{}}
