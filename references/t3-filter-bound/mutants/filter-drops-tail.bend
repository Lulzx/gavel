import Base
import ./prelude.bend as P

# The head is kept or dropped correctly and the tail is never looked at: the
# answer is at most one element, so `filter` is "is the first element below the
# threshold". The generated `constant-body` files answer `Nil{}` in every case;
# this one answers a list whose shape still follows the decision, which is what
# makes it worth having separately. `filter_len` fails at the second element,
# and `filter_keep` fails definitionally (`h <> Nil{}` against
# `h <> filter(t, h)` at a variable `t`).
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.filter_put(h, Nil{}, P.le(h, n))

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
