import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `pred_succ` is definitional: `pred` is the deconstructor of `Nat`, so
# `pred(1n+x)` already computes to `x`.
def L.pred_succ(x):
  {==}

# `add_one` is inductive in `x`. The successor case needs the fact that
# `add(p, 1n)` is `1n+p`, which is the induction hypothesis itself, so the step
# is just the hypothesis rewritten at `p`.
def L.add_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_one(p) : {1n+S.add(p, 1n) == 1n+_ : Nat}
      {==}

# `pred` matches on its argument, so `pred(0n)` is `0n` by unfolding. The binder
# is unused on purpose: every law in this bank is instantiated through one.
def L.pred_zero(x):
  {==}
