import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the count is `0n`, which is the first case of the match on `n`,
# and that case answers `0n` without looking at the list.
def L.count_odd_prefix_zero(xs):
  {==}

# An induction in `xs`. `len(xs)` reduces to `1n + len(t)` in the cons case, so
# the count steps there as well; both sides then reduce to `P.is_odd(h)` added
# to the hypothesis at `t`.
def L.count_odd_prefix_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.count_odd_prefix_len(t) : {P.is_odd(h) + S.count_odd_prefix(P.len(t), t) == P.is_odd(h) + _ : Nat}
      {==}

# Definitional in both cases of the count: at zero the count case answers `0n`,
# and at a successor the inner match on the empty list answers `0n` too.
def L.count_odd_prefix_nil(k):
  match k:
    case 0n:
      {==}
    case 1n+kp:
      {==}
