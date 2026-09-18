import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the count is `0n`, which is the first case of the match on `n`,
# and that case answers `0n` without looking at the list.
def L.sum_prefix_zero(xs):
  {==}

# An induction in `xs`. `len(xs)` reduces to `1n + len(t)` in the cons case, so
# the count steps there as well; both sides then reduce to the same head added
# to the hypothesis at `t`.
def L.sum_prefix_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.sum_prefix_len(t) : {h + S.sum_prefix(P.len(t), t) == h + _ : Nat}
      {==}

# The list is a literal `Nil{}`, so the inner match is picked for every count,
# but the outer match on `k` is stuck while `k` is a variable: the induction is
# on `k`, and both cases reduce to `0n`.
def L.sum_prefix_nil(k):
  match k:
    case 0n:
      {==}
    case 1n+kp:
      {==}
