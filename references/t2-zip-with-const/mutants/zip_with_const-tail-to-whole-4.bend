import Base
import ./prelude.bend as P

# The reference: step on the list. The empty list has nothing left to pack and
# answers the empty list. A cons cell answers its own element packed with the
# constant -- the element in the first component, the constant in the second --
# in front of the pairs of the tail. The constant is read twice in the step, so
# it is declared reusably.
def zip_with_const(xs: List<Nat>, +k: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{h, k} <> zip_with_const(xs, k)
