import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the outer match.
def L.count_runs_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes the
# cons case and the inner match takes its empty case.
def L.count_runs_single(x):
  {==}

# `P.is_eq` steps one successor off each side at once, so `P.is_eq(a, a)` is
# stuck on a variable `a` and the reflexivity of the decision is not
# definitional: it is an induction on `a`, which is what `count_runs_same`
# needs. The statement is oriented with `1n` on the left because a rewrite step
# replaces the side the hole in the pattern stands for.
def Policy.is_eq_refl(a: Nat) -> {1n == P.is_eq(a, a) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_eq_refl(p) : {1n == _ : Nat}
      {==}

# The step leaves `P.nsub(1n, P.is_eq(a, a)) + count_runs(a <> t)` against
# `count_runs(a <> t)`. The reflexivity lemma rewrites the decision to `1n`,
# `P.nsub(1n, 1n)` is zero, and what is left is an identity.
def L.count_runs_same(a, t):
  %Policy.is_eq_refl(a) : {P.nsub(1n, _) + S.count_runs(a <> t) == S.count_runs(a <> t) : Nat}
  {==}

# The premise is the law's own hypothesis: it states that the two elements
# differ, and `Equal.sym` turns it into the orientation the rewrite needs -- the
# `0n` that takes the place of `P.is_eq(a, b)`. The step then leaves
# `1n + count_runs(b <> t)` on both sides.
def L.count_runs_diff(a, b, t, e):
  %Equal.sym(Nat, P.is_eq(a, b), 0n, e) :
      {P.nsub(1n, _) + S.count_runs(b <> t) == 1n + S.count_runs(b <> t) : Nat}
  {==}
