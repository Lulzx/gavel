import Base
import ./prelude.bend as P

# Every element replaced by the cap itself, rather than capped against it: the
# reading that takes "cap everything above `n`" to mean "make everything `n`".
# Rejected by `min_all_single`, whose left-hand side reduces to `n <> Nil{}`
# where the law wants `P.min(h, n) <> Nil{}` -- the variable `n` against the
# stuck `P.min(h, n)`. The step names `n` twice, so it is re-bound with `+k` as
# the reference's is.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      k <> min_all(t, k)
