import Base
import ./prelude.bend as P

# The threshold is not carried into the recursion: the tail is filtered against
# the head instead of against `n`, so every element after the first is compared
# with the wrong number. The decision for the current head is still `P.le(h, n)`,
# so the body is not obviously wrong at the first position; `filter_len` is the
# exact-count law that catches it, and `filter_drop` fails too whenever the
# head is above the threshold, because the tail is then filtered against it.
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.filter_put(h, filter(t, h), P.le(h, n))

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
