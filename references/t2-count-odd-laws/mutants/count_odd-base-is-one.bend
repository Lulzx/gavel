import Base
import ./prelude.bend as P

# The empty list is counted as one odd element, so every count is one too high.
# `count_odd_nil` states the empty answer outright and refuses it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.count_odd_nil`.
def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.is_odd(h) + count_odd(t)
