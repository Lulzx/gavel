import Base
import ./prelude.bend as P

# Answers the empty list on every successor, so only `n = 0` is right and every
# other count collapses to nothing. The zero case is the reference's and
# `nappend_zero` holds; `nappend_succ` rejects it, wanting
# `P.append(xs, S.nappend(xs, p))` where this computes to `Nil{}`. The length law
# rejects it as well, on every `n` but zero.
def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      Nil{}
