import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the match steps on the cons cell and then on the successor
# count, and both sides are `at(xs, k)`.
def L.at_succ(h, k, xs):
  {==}

# An induction in `xs`. The `Nil{}` case is the head case of `at`; the cons case
# reduces to the hypothesis at `t`.
def L.at_len_append(xs, y):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.at_len_append(t, y) : {S.at(P.append(t, y <> Nil{}), P.len(t)) == _ : Nat}
      {==}

# Definitional: the match on the empty list answers `0n` without looking at the
# count, so both sides are `0n` for every `n`.
def L.at_nil(n):
  {==}
