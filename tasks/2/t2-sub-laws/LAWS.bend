import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: taking nothing away leaves the number alone. Alone it does not pin
# `sub`: the projection `sub(a, b) = a` satisfies it, and that body never looks
# at the subtrahend.
law sub_zero:
  for x: Nat
  {S.sub(x, 0n) == x : Nat}

# LAW: one step of the subtrahend is one step of `pred` off the result. Alone
# it does not pin `sub` either: the constant body `0n` satisfies it, since both
# sides are then `0n`. Together the two laws do pin it -- `sub_zero` fixes every
# `sub(x, 0n)`, and this law reduces `sub(x, 1n+y)` to a smaller second
# argument, which is all an induction on `y` needs.
law sub_succ:
  for x: Nat
  for y: Nat
  {S.sub(x, 1n+y) == P.pred(S.sub(x, y)) : Nat}
