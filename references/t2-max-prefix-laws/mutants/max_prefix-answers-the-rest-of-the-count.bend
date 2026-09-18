import Base
import ./prelude.bend as P

# The inner `Nil{}` hands back the count that is left instead of `0n` -- the
# other free answer in the same unreachable case, and the one a body that read
# the count as a bound rather than a target would give.
# Measured: before `max_prefix_nil`, tier 4, reward 1.000; after, tier 3, reward
# 0.433 for the two older laws, first failure at `LAWS.max_prefix_nil`.
def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          k
        case h <> t:
          P.max(h, max_prefix(k, t))
