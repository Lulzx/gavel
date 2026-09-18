import Base
import ./prelude.bend as P

# The head is consed on unchanged: the recursion is right and `P.min` is never
# applied, which is a plausible slip for a cap whose function is named
# separately. Rejected by `min_all_single`, whose left-hand side reduces to
# `h <> Nil{}` where its right-hand side is `P.min(h, n) <> Nil{}` -- the
# variable `h` against the stuck `P.min(h, n)`. `min_all_append` holds only at
# the empty `xs`; the checker stops at the base law.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> min_all(t, n)
