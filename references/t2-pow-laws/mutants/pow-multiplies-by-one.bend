import Base

# Every exponent of one or more multiplies by one, so `pow(x, n)` is `x` for
# every `n >= 1`. It reached tier 4 -- full reward -- before `pow_succ` existed:
# `pow_zero` fixes the exponent only at zero and `pow_one` only at one, so no
# law in the set constrained the step. Measured: bare tier 2, killed first at
# `LAWS.pow_succ`. Its sibling, `case 1n+p -> a`, is the same mistake and reads
# as caught only because the proof's `Policy.mul_one_right` rewrite looks for
# `Nat.mul(x, 1n)` in the goal -- caught by the proof's shape rather than by a
# law, which is why the repair is a law and not another mutant.
def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      1n
    case 1n+p:
      Nat.mul(a, 1n)
