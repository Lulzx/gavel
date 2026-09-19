import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `add` is Base's addition. `double_eq_add` names `add` only on the
# diagonal `add(x, x)`, so a pair -- a `double` that is doubling and an `add`
# that is anything agreeing with `+` where both arguments are equal -- leaves
# the off-diagonal free. Written the other way round, `x + y` is Base's
# addition and `S.add` is the policy's, so this law is what makes the stub's
# first obligation an obligation. The same shape was closed in `t1-mul-zero`
# (Fact 33) and this is its second instance.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, y) == x + y : Nat}

# LAW: doubling is adding a number to itself.
law double_eq_add:
  for x: Nat
  {S.double(x) == S.add(x, x) : Nat}

# LAW: one more on the argument is two more on the result. This is the step
# `double` recurses with, so it closes by reduction; it is what keeps the pair
# from being satisfied by a `double` that ignores its argument.
law double_succ:
  for x: Nat
  {S.double(1n+x) == 1n+1n+S.double(x) : Nat}
