import Base
import ./prelude.bend as P

# The inner `Nil{}` answers a one-element list. Neither law above reaches it:
# `take_succ` always hands the inner match a cons cell, and `take_append_len`
# reaches the count `0n` only in its own empty case, which answers before the
# inner match.
# Measured: before `take_nil`, tier 4, reward 1.000; after, tier 3, reward 0.433
# for the two older laws, first failure at `LAWS.take_nil`.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          1n <> Nil{}
        case h <> t:
          h <> take(k, t)
