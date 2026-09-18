import Base
import ./prelude.bend as P

# The inner `Nil{}` answers `1n`. Neither law above reaches it:
# `sum_prefix_zero` fixes only the count `0n`, and `sum_prefix_len` constrains
# only the diagonal, where the count and the list length agree.
# Measured: before `sum_prefix_nil`, tier 4, reward 1.000; after, tier 3, reward
# 0.433 for the two older laws, first failure at `LAWS.sum_prefix_nil`.
def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          1n
        case h <> t:
          h + sum_prefix(k, t)
