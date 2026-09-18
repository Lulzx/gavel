import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the count is `0n`, which is the first case of the match on `n`,
# and that case answers `0n` without looking at the list.
def L.zeros_prefix_zero(xs):
  {==}

# An induction in `xs`. `len(xs)` reduces to `1n + len(t)` in the cons case, so
# the count steps there as well; both sides then reduce to the same `is_zero(h)`
# added to the hypothesis at `t`, which is why the head needs no split of its
# own -- in particular not through `is_zero`.
def L.zeros_prefix_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.zeros_prefix_len(t) : {P.is_zero(h) + S.zeros_prefix(P.len(t), t) == P.is_zero(h) + _ : Nat}
      {==}

# The list is a literal `Nil{}`, so the inner match is picked for every count,
# but the outer match on `k` is stuck while `k` is a variable: the induction is
# on `k`, and both cases reduce to `0n`.
def L.zeros_prefix_nil(k):
  match k:
    case 0n:
      {==}
    case 1n+kp:
      {==}
