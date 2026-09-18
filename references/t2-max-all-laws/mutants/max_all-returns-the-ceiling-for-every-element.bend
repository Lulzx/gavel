import Base
import ./prelude.bend as P

# Every cell is answered with the ceiling `n` instead of the larger of the two.
# The singleton law asks for `P.max(h, n)` and the two sides do not reduce to
# the same term.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.max_all_single`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      k <> max_all(t, k)
