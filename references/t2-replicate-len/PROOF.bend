import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `replicate_succ` is definitional: `replicate` steps on the count, so both
# sides reduce to `x <> replicate(n, x)`.
def L.replicate_succ(n, x):
  {==}

# `replicate_len` is inductive in `n`: `len` matches on its first argument, so
# with a variable `n` the goal does not reduce on its own. The step case leaves
# `1n + len(replicate(p, x))` against `1n + p`, which is the hypothesis at `p`.
def L.replicate_len(n, x):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %L.replicate_len(p, x) : {1n + P.len(S.replicate(p, x)) == 1n + _ : Nat}
      {==}
