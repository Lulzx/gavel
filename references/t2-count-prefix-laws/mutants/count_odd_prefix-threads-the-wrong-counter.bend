import Base
import ./prelude.bend as P

# A body a person would plausibly write: the recursion passes the count it was
# given rather than the decremented one, so no matter where the prefix ends the
# walk carries on to the end of the list. Rejected by
# `count_odd_prefix_len`: at the cons case of its induction the law wants the
# head's test added to the answer for the *rest*, and this body's answer for the
# rest has already consumed the head.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_odd(h) + count_odd_prefix(n, t)
