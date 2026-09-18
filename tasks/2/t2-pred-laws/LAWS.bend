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
