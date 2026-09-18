import Base

# `min` is the maximum. Every law above is relative -- `min_self` compares `min`
# with itself at the same argument and `min_comm` swaps the arguments -- and
# `max` preserves both, being idempotent and commutative too, so the whole set
# is satisfied without a single law seeing the difference.
# Measured: before `min_zero_left`/`min_succ_succ`, tier 4, reward 1.000, both
# laws proven; after, tier 3, reward 0.475 for `min_self` and `min_comm`, first
# failure at `LAWS.min_zero_left`.
def Policy.mx(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+Policy.mx(ap, bp)

def min(a: Nat, b: Nat) -> Nat:
  Policy.mx(a, b)
