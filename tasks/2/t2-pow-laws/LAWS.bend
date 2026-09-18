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
