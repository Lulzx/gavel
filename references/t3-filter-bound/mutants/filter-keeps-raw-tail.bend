import Base
import ./prelude.bend as P

# The head is decided on correctly and the tail is emitted unfiltered, so the
# answer keeps every element above the threshold that does not come first. It
# is the body that shows why `filter_keep` is stated about the *answer* and not
# only about the count: `filter(h <> t, h)` reduces to `h <> t`, where the law
# wants `h <> filter(t, h)`, and the two are not convertible at a variable `t`.
# `filter_len` is off by every dropped element of the tail.
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.filter_put(h, t, P.le(h, n))

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
