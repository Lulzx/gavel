import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so both
# sides reduce to `0n` by unfolding alone.
def L.last_index_of_nil(k):
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides
# reduce to the same decision on `P.has_k(t, k)` with the same two answers.
def L.last_index_of_step(h, k, t):
  {==}

# `eq` steps one successor off both of its arguments at once, so `eq(1n+p, 1n+p)`
# reduces to `eq(p, p)` and the hypothesis at `p` is the whole of what is left.
# It is a lemma of its own, under the reserved `Policy.*` namespace, because
# `eq(k, k)` is stuck where it is written.
def Policy.eq_refl(k: Nat) -> {P.eq(k, k) == True{} : Bool}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      %Policy.eq_refl(p) : {P.eq(p, p) == _ : Bool}
      {==}

# No element of `inc_all(xs)` is `0n`: the step's head is a successor, so `eq` on
# it answers `False{}` by unfolding whatever its predecessor is, and the walk
# moves on to the tail. The induction leaves `has_k` at the tail for the
# hypothesis.
def Policy.has_k_inc_all(xs: List<&2, Nat>) -> {P.has_k(P.inc_all(xs), 0n) == False{} : Bool}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.has_k_inc_all(t) : {P.has_k(P.inc_all(t), 0n) == _ : Bool}
      {==}

# Inductive in `xs`. The step walks the shifted head with a `False{}` -- nothing
# in the shift is `0n` -- so the decision on it is the second answer, and the
# head's own comparison is `eq(1n + h, 0n)`, which is `False{}` by unfolding
# because the second match is taken at `0n` whatever the predecessor is. That
# leaves `1n + last_index_of(inc_all(t), 0n)` against the length of the input,
# which is the same one for the head and the hypothesis at the tail.
def L.last_index_of_miss(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Equal.sym(Bool, P.has_k(P.inc_all(t), 0n), False{}, Policy.has_k_inc_all(t)) : {P.at_if(_, 1n + S.last_index_of(P.inc_all(t), 0n), P.at_if(P.eq(1n + h, 0n), 0n, 1n + S.last_index_of(P.inc_all(t), 0n))) == P.len(h <> t) : Nat}
      %Equal.sym(Nat, S.last_index_of(P.inc_all(t), 0n), P.len(t), L.last_index_of_miss(t)) : {1n + _ == P.len(h <> t) : Nat}
      {==}

# A hit at the head with a shifted tail behind it. The walk of the shifted tail
# answers `False{}` by the lemma, so the decision on it is the second answer, and
# the head's comparison is `eq(0n, 0n)`, which unfolds to its first answer: the
# answer is `0n`. No induction is needed -- the tail's own answer is never read,
# because the head's occurrence is the last one.
def L.last_index_of_hit(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Equal.sym(Bool, P.has_k(P.inc_all(t), 0n), False{}, Policy.has_k_inc_all(t)) : {P.at_if(_, 1n + S.last_index_of(P.inc_all(h <> t), 0n), P.at_if(P.eq(0n, 0n), 0n, 1n + S.last_index_of(P.inc_all(h <> t), 0n))) == 0n : Nat}
      {==}

# A later occurrence wins. The step unfolds to `at_if(has_k(t, k), 1n + ...,
# at_if(eq(k, k), 0n, 1n + ...))`, and `eq(k, k)` is not reducible on its own, so
# the comparison is settled by the lemma above -- flipped, because the goal has
# the term being rewritten on the left -- and the decision then unfolds to `0n`,
# which is the law's right-hand side whether or not the tail still holds `k`.
def L.last_index_of_last_wins(k, t):
  %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.at_if(P.has_k(t, k), 1n + S.last_index_of(t, k), P.at_if(_, 0n, 1n + S.last_index_of(t, k))) == P.at_if(P.has_k(t, k), 1n + S.last_index_of(t, k), 0n) : Nat}
  {==}
