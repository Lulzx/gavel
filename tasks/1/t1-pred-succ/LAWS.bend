import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the predecessor of a successor is the original number.
law pred_succ:
  for x: Nat
  {S.pred(1n+x) == x : Nat}

# LAW: the predecessor of `x + 1`, with the successor built by `add`, is `x`.
# Inductive in `x`, and it is what keeps the pair from being satisfied by a
# `pred` that ignores its argument.
law pred_add_one:
  for x: Nat
  {S.pred(S.add(x, 1n)) == x : Nat}

# LAW: the predecessor of zero is zero. Both laws above apply `pred` to a
# successor -- `1n+x`, and `add(x, 1n)`, which reduces to one -- so the `0n`
# case is reached by neither left-hand side. A `pred` answering `1n` there
# proves both at tier 4, reward 1.000. This is the closed-value anchor.
law pred_zero:
  for x: Nat
  {S.pred(0n) == 0n : Nat}

# LAW: adding zero on the right changes nothing. `pred_add_one` is the only law
# here that applies `add`, and it applies the second argument at the single
# value `1n` -- so `add` is observed at `add(x, 1n)` and nowhere else, and a body
# is free everywhere the laws do not look: `add(a, b) = 1n + a`, an `add` that
# ignores `b` entirely, satisfies `pred_add_one` because at `b = 1n` it is
# `1n + a` and the law's `pred` steps on exactly that. Measured 2026-09-19
# against the three laws above: tier 4, complete, reward 1.000, `failed` empty.
# This is the closed-value anchor that names the argument the other three never
# observe; combined with `pred_add_one` it fixes `add` at its base and at one
# step, which is the same pair `t1-mul-two` carries for the same reason.
law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}

# LAW: the step of `add`'s *second* argument, and the one that makes the set
# determine it. `add_zero` names one value and `pred_add_one` applies `add` at
# one more, so a body can agree at both and disagree everywhere above: measured
# 2026-09-19 against the four laws above it, an `add` answering `a` at `0n`,
# `1n + a` at `1n` and `a + b + 1` from `2n` up proves all four at tier 4,
# reward 1.000, `failed` empty. This is `add`'s recursion in the argument the
# other laws do not step, and with `add_zero` it fixes the function at every
# input. Unlike the reference's own unfolding it is *not* definitional here --
# the reference recurses on its first argument -- so it is proved by induction
# on `a`, and it is the one law in this set that is not closed by reduction.
law add_succ:
  for a: Nat
  for b: Nat
  {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}
