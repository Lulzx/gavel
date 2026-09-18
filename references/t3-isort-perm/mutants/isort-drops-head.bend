import Base
import ./prelude.bend as P

# `isort` sorts the tail and never inserts the head: the recursion is written
# and its result is returned directly. It is still a permutation of a *sub*list,
# which is why the count law is the one that has to see it -- the law is stated
# against `count(z, xs)` at the same `xs`, and this body loses the head's
# occurrence. `insert` is the reference's, so the two order laws are untouched.
# Measured: `LAWS.isort_count` fails first, with `insert_count` proven in
# isolation and the two order laws failing on the proof's shape.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, P.le(y, h))

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      isort(t)
