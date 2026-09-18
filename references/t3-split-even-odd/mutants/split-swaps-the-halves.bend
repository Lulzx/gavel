import Base
import ./prelude.bend as P

# The two halves are the right halves of the right sublists and they come back
# in the other order, so every element is in the wrong half. The step law is
# definitional and states the answer as `MkL{h <> odds, evens}`, which is what
# makes this body unconvertible there; the nil law holds, and the length law
# holds too, since it adds the two lengths together and a swap does not change
# the sum -- which is why the step law is not optional. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.split_len_induction`.
def split(+xs: List<&2, Nat>) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.MkL{P.evens(split(t)), h <> P.odds(split(t))}
