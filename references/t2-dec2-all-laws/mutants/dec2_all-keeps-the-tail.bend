import Base
import ./prelude.bend as P

# The mapped head is consed onto the *unmapped* tail: a plausible slip when the
# recursion is written out of order, since the head gets its function and the
# tail does not. `dec2_all_single` holds -- at `h <> Nil{}` the tail is already
# `Nil{}`, so the body's answer is `P.dec2(h) <> Nil{}` -- and it is
# `dec2_all_append` that rejects it, at the cons step: `dec2_all([1n, 2n])` is
# `0n <> (2n <> Nil{})` by this body, where the law's right-hand side is
# `0n <> (0n <> Nil{})`. The reference proof's step fails there too, since its
# rewrite looks for `dec2_all` applied to the appended tail, which this body
# never forms.
def dec2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.dec2(h) <> t
