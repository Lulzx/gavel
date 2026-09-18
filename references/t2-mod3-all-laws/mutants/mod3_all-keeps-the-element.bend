import Base
import ./prelude.bend as P

# The head is consed on unchanged: the recursion is right and `P.mod3` is never
# applied, which is a plausible slip for a map whose function is named
# separately. Rejected by `mod3_all_single`, whose left-hand side reduces to
# `h <> Nil{}` where its right-hand side is `P.mod3(h) <> Nil{}` -- the variable
# `h` against the stuck `P.mod3(h)`. `mod3_all_append` holds only at the empty
# `xs`; the checker stops at the base law.
def mod3_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> mod3_all(t)
