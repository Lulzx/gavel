import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: half of nothing is nothing. It is definitional, and it is the weak half:
# the constant body `0n` satisfies it.
law half_zero:
  {S.half(0n) == 0n : Nat}

# LAW: half of an even number is one more than half of what is two below it.
# This is the definitional unfolding of `half`, and that is exactly why the
# task was abandoned: `1n + 1n + p` is constructor-headed, so the law reduces
# away and a `{==}`-only proof discharges it. V3 rejects the task on that
# ground -- the reward was earnable without solving anything.
law half_succ:
  for p: Nat
  {S.half(1n + 1n + p) == 1n + S.half(p) : Nat}
