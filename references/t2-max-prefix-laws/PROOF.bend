import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the count is `0n`, which is the first case of the match on `n`,
# and that case answers `0n` without looking at the list.
def L.max_prefix_zero(xs):
  {==}

# An induction in `xs`. `len(xs)` reduces to `1n + len(t)` in the cons case, so
# the count steps there as well; both sides then reduce to `max` applied to the
# same head and to the hypothesis at `t`.
def L.max_prefix_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.max_prefix_len(t) : {P.max(h, S.max_prefix(P.len(t), t)) == P.max(h, _) : Nat}
      {==}
