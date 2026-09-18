import Base
import ./prelude.bend as P

# The head is consed on unchanged: the recursion is right and `P.dec2` is never
# applied, which is a plausible slip for a map whose function is named
# separately. Rejected by `dec2_all_single`, whose left-hand side reduces to
# `h <> Nil{}` where its right-hand side is `P.dec2(h) <> Nil{}` -- the variable
# `h` against the stuck `P.dec2(h)`. The reference proof's `dec2_all_append`
# fails as well, and for a reason that is about the proof rather than the body:
# its step rewrites under the motive `P.dec2(h) <> _`, which the goal does not
# have once the head is left unmapped.
def dec2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> dec2_all(t)
