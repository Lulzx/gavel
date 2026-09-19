import Base
import ./prelude.bend as P

# PROBE. The walk and its two laws are untouched; only the seed differs -- the
# head is put in the second slot as well as the first, so a one-element list
# answers its own element.
def sec_go(xs: List<&2, Nat>, +top: Nat, second: Nat) -> Nat:
  match xs:
    case Nil{}:
      second
    case +h <> t:
      sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second))

def second_max(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> t:
      sec_go(t, h, h)
