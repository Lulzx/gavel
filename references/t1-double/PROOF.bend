import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `add_succ_rev` is the successor law for `add`, oriented so that a goal
# carrying `1n + add(x, y)` can step to `add(x, 1n+y)`. Free in `y`, so the
# induction in `x` passes it through unchanged.
def Policy.add_succ_rev(x: Nat, y: Nat) -> {1n+S.add(x, y) == S.add(x, 1n+y) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ_rev(p, y) : {2n+S.add(p, y) == 1n+_ : Nat}
      {==}

# The step goal is `2n + double(p) == 1n + add(p, 1n+p)`. The successor law
# turns its right side into `2n + add(p, p)`, which the hypothesis closes.
# `p` is named twice, so it is re-bound reusable first.
def L.double_eq_add(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      %Policy.add_succ_rev(p, p) : {2n+S.double(p) == 1n+_ : Nat}
      %L.double_eq_add(p) : {2n+S.double(p) == 2n+_ : Nat}
      {==}

# `double` steps on its argument, so both sides are the same term after one
# reduction: no induction is needed.
def L.double_succ(x):
  {==}
