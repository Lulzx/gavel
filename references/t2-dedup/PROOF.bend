import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `same` steps one successor off each side at once, so `same(a, a)` is stuck on a
# variable `a` and the reflexivity of the decision is not definitional: it is an
# induction on `a`, which is what `dedup_same` needs. The statement is oriented
# with `True{}` on the left because a rewrite step replaces the side that the
# hole in the pattern stands for.
def Policy.same_refl(a: Nat) -> {True{} == P.same(a, a) : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.same_refl(p) : {True{} == _ : Bool}
      {==}

# The input is the literal `Nil{}`, which is the first case of the outer match.
def L.dedup_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes the
# cons case and the inner match takes its empty case.
def L.dedup_single(x):
  {==}

# The outer match takes the cons case and the inner match sees the cons tail, so
# both sides reduce to a `same_put` on the same decision, the same recursive call
# and the same head.
def L.dedup_cons(a, b, t):
  {==}

# The step leaves `same_put(a, dedup(a <> t), same(a, a))` against `dedup(a <> t)`.
# The reflexivity lemma rewrites the decision to `True{}`, `same_put` then takes
# its first answer, and what is left is an identity.
def L.dedup_same(a, t):
  %Policy.same_refl(a) : {P.same_put(a, S.dedup(a <> t), _) == S.dedup(a <> t) : List<&2, Nat>}
  {==}
