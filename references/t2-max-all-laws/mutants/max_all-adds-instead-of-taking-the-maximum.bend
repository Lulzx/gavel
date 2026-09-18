import Base
import ./prelude.bend as P

# The larger of the element and the ceiling is computed as their sum: the
# comparison is dropped. The singleton law fails, since `h + n` and
# `P.max(h, n)` are both stuck and are not the same term.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.max_all_single`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      (h + k) <> max_all(t, k)
