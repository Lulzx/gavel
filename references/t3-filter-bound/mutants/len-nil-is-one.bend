import Base
import ./prelude.bend as P

# `len` answers one for the empty list -- the off-by-one in the base case, with
# the recursion correct. Every case of `filter` is the reference's, so the exact
# count law is the only thing that can see it, and it sees it definitionally at
# `xs = Nil{}`: `1n` against `P.below_count(Nil{}, n)`, which is `0n`.
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.filter_put(h, filter(t, n), P.le(h, n))

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      1n + len(t)
