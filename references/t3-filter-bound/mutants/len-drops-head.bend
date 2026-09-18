import Base
import ./prelude.bend as P

# `len` counts the tail and forgets the head, so it is off by one on every
# non-empty list. `filter` is the reference's -- the interesting thing about
# this file is that the length law is stated against `S.len` and `P.below_count`
# together, so a wrong `len` and a wrong `filter` are the same failure to the
# law. It is also the reason the two functions are both policy targets.
# Measured: rejected at `Policy.step`, the length law's helper, with all three
# laws reported unproven.
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.filter_put(h, filter(t, n), P.le(h, n))

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      len(t)
