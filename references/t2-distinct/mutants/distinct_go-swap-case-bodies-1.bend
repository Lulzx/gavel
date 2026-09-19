import Base
import ./prelude.bend as P

# The walk carries every element it has already kept, and tests each new element
# against that whole set rather than against the element next to it -- which is
# what makes a duplicate disappear however far it sits from its first
# occurrence.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> seen))

    case +h <> t:
      Nil{}

def distinct(xs: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> distinct_go(t, h <> Nil{})
