import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both sides compute: `sum` folds the cons that `<>` builds, so the head lands
# outside the recursive sum and nothing is left to rewrite.
def L.sum_cons(h, t):
  {==}

# `replicate` grows the run on the right, so its successor count unfolds to a
# cons whose head is `x`; `sum` then puts `x +` outside and the hypothesis
# replaces the tail. `P.mul(1n + k, x)` already computes to `x + P.mul(k, x)`,
# so the step ends definitionally.
def L.sum_replicate_mul(n, x):
  match n:
    case 0n:
      {==}
    case 1n+k:
      %Equal.sym(Nat, S.sum(P.replicate(k, x)), P.mul(k, x), L.sum_replicate_mul(k, x)) : {x + _ == x + P.mul(k, x) : Nat}
      {==}

# The same induction at the element `1n`: the step unfolds to `1n +` on both
# sides, and `1n + k` is the successor form the count already is.
def L.sum_replicate_one(n):
  match n:
    case 0n:
      {==}
    case 1n+k:
      %Equal.sym(Nat, S.sum(P.replicate(k, 1n)), k, L.sum_replicate_one(k)) : {1n + _ == 1n + k : Nat}
      {==}
