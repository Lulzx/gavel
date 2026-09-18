import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: any base to the power zero is one. Alone it does not pin `pow`: the
# constant body `1n` satisfies it.
law pow_zero:
  for x: Nat
  {S.pow(x, 0n) == 1n : Nat}

# LAW: any base to the power one is itself. Alone it does not pin `pow`
# either: the projection `pow(a, b) = a` satisfies it. Together the two laws
# do pin it -- `pow_zero` kills that projection, and `pow_one` kills every
# constant.
law pow_one:
  for x: Nat
  {S.pow(x, 1n) == x : Nat}

# LAW: a successor exponent is the base times the power of its predecessor. The
# two laws above fix only exponents zero and one, so a `pow` that multiplied by
# one at every higher exponent -- `pow(x, n) = x` for every `n >= 1` -- proved
# both at full reward. This law fixes the step at a variable exponent.
law pow_succ:
  for x: Nat
  for p: Nat
  {S.pow(x, 1n+p) == Nat.mul(x, S.pow(x, p)) : Nat}
