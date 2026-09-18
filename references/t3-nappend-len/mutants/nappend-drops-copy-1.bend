import Base
import ./prelude.bend as P

# Recurses but never concatenates: the count goes down and the list is not
# accumulated, so the answer is whatever the last step produced. It type-checks,
# the zero case is the reference's and `nappend_zero` holds; `nappend_succ` is
# the law that rejects it, wanting `P.append(xs, S.nappend(xs, p))` where this
# computes to the bare `S.nappend(xs, p)`. The length law fails as well, on every
# `n` above one.
def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      nappend(xs, p)
