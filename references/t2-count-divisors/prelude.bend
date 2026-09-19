import Base

# Immutable, and owned by the task rather than the policy. `count_divisors` is
# what the policy implements; `is_zero` and `divides` are here because the walk
# has to answer two different ways on a division, and a `match` cannot
# scrutinise a computed value.

# Whether a number is zero. One constructor at a time, so with a variable the
# answer does not reduce: that `Nat.mod(n, k)` is zero for a `k` that divides
# `n` is a fact about the numbers, not an unfolding.
def is_zero(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      False{}

# Whether `b` divides `a`, exactly. It is the remainder test and nothing else:
# `Nat.mod(a, b)` is zero exactly when `b` is a divisor of `a`. The remainder is
# a computed term, so the comparison is a term built out of `is_zero` rather
# than a `match` on it.
def divides(a: Nat, b: Nat) -> Bool:
  is_zero(Nat.mod(a, b))
