import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Adding one on the right is adding one on the left. Inductive in `x`; the
# step's hypothesis is `add(p, 1n) == 1n+p`, which is the whole goal.
def Policy.add_one_comm(x: Nat) -> {S.add(x, 1n) == 1n + x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_one_comm(p) : {1n + S.add(p, 1n) == 1n + _ : Nat}
      {==}

# `pred` steps on its argument, so `pred` of `1n+x` is `x` by reduction alone.
def L.pred_succ(x):
  {==}

# The base case closes by reduction: `add(0n, 1n)` is `1n` and `pred` of it is
# `0n`. The step reduces to `{S.add(p, 1n) == 1n+p}`, which is the lemma.
def L.pred_add_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_one_comm(p) : {S.add(p, 1n) == _ : Nat}
      {==}
