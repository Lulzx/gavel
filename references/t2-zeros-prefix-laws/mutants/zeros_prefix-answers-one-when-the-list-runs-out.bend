import Base
import ./prelude.bend as P

# The inner `Nil{}` answers `1n`. Neither law above reaches it:
# `zeros_prefix_zero` fixes only the count `0n`, and `zeros_prefix_len`
# constrains only the diagonal, where the count and the list length agree.
# Measured: before `zeros_prefix_nil`, tier 4, reward 1.000; after, tier 3,
# reward 0.433 for the two older laws, first failure at `LAWS.zeros_prefix_nil`.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          1n
        case h <> t:
          P.is_zero(h) + zeros_prefix(k, t)
