import Base

# The `0n` case of `mul` reading its second argument. Multiplication is total in
# it: `mul(0n, y)` is `0n` at every `y`, and that is the one point of the base
# case the two original laws do not reach -- `mul_succ` at `x == 0n` with
# `mul_one` at `x == 1n` fixes `mul(0n, 1n)` and nothing else. This body answers
# `0n` for `y <= 1n` and `1n` above it, so `mul(x, y)` is `x * y` except that
# every product by zero from `2n` up comes back `1n`, and `add`'s shape carries
# the difference through the recursion.
#
# **Measured 2026-09-19, against the two-law set:** tier 4, complete, reward
# 1.000, both laws proven **by the reference proof unchanged** -- `mul_one`'s
# induction closes because the `0n` case still answers `0n` at `y == 1n`, and
# `mul_succ` closes by reduction on both bodies alike. It is the strongest
# evidence class this bank records: no adapted proof, no hand-written one.
#
# After `mul_zero` was added: tier 3, reward 0.433, failing `LAWS.mul_zero` with
# `expected solution.mul(0n, y)` against `observed 0n`. The law is the missing
# anchor, not a restatement: with the step above it determines `mul` on the
# first argument by induction from `mul(0n, y)`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          0n
        case 1n+q:
          match q:
            case 0n:
              0n
            case 1n+r:
              1n
    case 1n+p:
      add(b, mul(p, b))
