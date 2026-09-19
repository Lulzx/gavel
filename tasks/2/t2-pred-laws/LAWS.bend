import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the predecessor of a successor is the number itself.
law pred_succ:
  for x: Nat
  {S.pred(1n+x) == x : Nat}

# LAW: adding one on the right is adding one on the left. This is the law that
# pins `add`: `pred_succ` constrains only `pred`, and an `add` that returned its
# second argument would satisfy a law stated over `S.add` as easily as the real
# one.
#
# It pins `add` at one value of the second argument and nowhere else, and the
# comment here used to claim it pinned the function. Measured 2026-09-19 against
# the three laws then in the set: `add(a, b) = 1n + a`, which never looks at
# `b`, reads **tier 4, complete, reward 1.000**, `failed` empty -- at `b = 1n` it
# answers `1n + x`, which is the whole of this law. `add_zero` and `add_succ`
# below are what close that, and they are the same pair `t1-pred-succ` carries.
law add_one:
  for x: Nat
  {S.add(x, 1n) == 1n+x : Nat}

# LAW: the predecessor of zero is zero. `pred_succ` applies `pred` only to a
# successor and `add_one` does not mention `pred` at all, so the `0n` case is
# reached by no left-hand side. A `pred` answering `1n` there proves both laws
# at **tier 4, reward 1.000** -- measured. This is the closed-value anchor.
law pred_zero:
  for x: Nat
  {S.pred(0n) == 0n : Nat}

# LAW: adding zero on the right changes nothing. `add_one` observes `add`'s
# second argument at the single value `1n`, so the base of that argument is
# reached by no law in the set. This is the closed-value anchor that names it.
law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}

# LAW: the step of `add`'s second argument, and the one that makes the set
# determine `add` rather than pin it at two points. `add_zero` names one value
# and `add_one` another, so a body can agree at both and disagree everywhere
# above: an `add` answering `a` at `0n`, `1n + a` at `1n` and `a + b + 1` from
# `2n` up proves every other law here at **tier 4, reward 1.000** -- measured
# 2026-09-19. This is `add`'s recursion in the argument the others do not step,
# and with `add_zero` it fixes the function at every input. It is not
# definitional, because the reference recurses on its first argument, so it is
# proved by induction on `a`; `add_one` follows from the two of them.
law add_succ:
  for a: Nat
  for b: Nat
  {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}
