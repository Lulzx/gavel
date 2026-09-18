import Base
import ./prelude.bend as P

# The capped head is consed onto the *uncapped* tail: a plausible slip when the
# recursion is written out of order, since the head gets capped and the rest do
# not. `min_all_single` holds -- at `h <> Nil{}` the tail is already `Nil{}`, so
# the body's answer is `P.min(h, n) <> Nil{}` -- and it is `min_all_append` that
# rejects it, at the cons step: the tail is never capped, so the elements after
# the first are capped by the law's side and untouched by the body's.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.min(h, n) <> t
