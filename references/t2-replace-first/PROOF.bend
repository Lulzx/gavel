import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the case of the match.
def L.replace_first_nil(k, y):
  {==}

# `P.eq` steps one successor off each side at once, so `P.eq(h, h)` is stuck on a
# variable and the reflexivity of the decision is not definitional: it is an
# induction on `h`, which is what the law about replacing the head needs. The
# statement is oriented with `True{}` on the left because a rewrite step replaces
# the side the hole in the pattern stands for.
def Policy.eq_refl(a: Nat) -> {True{} == P.eq(a, a) : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.eq_refl(p) : {True{} == _ : Bool}
      {==}

# The step leaves `P.rp_branch(P.eq(h, h), h, y, t, replace_first(t, h, y))`. The
# reflexivity lemma rewrites the decision to `True{}`, `P.rp_branch` takes its
# first case, and the tail comes back with `y` in front of it.
def L.replace_first_hit(h, t, y):
  %Policy.eq_refl(h) :
      {P.rp_branch(_, h, y, t, S.replace_first(t, h, y)) == y <> t : List<&2, Nat>}
  {==}

# The premise is the law's own hypothesis: it says the two elements differ, and
# `Equal.sym` turns it into the orientation the rewrite needs -- its left-hand
# side is the `False{}` that takes the place of the decision. The hole stands
# where the decision is, and `P.rp_branch` then takes its second case, so the
# head survives in front of the recursive call.
def L.replace_first_miss(a, b, t, y, e):
  %Equal.sym(Bool, P.eq(a, b), False{}, e) :
      {P.rp_branch(_, a, y, t, S.replace_first(t, b, y))
         == a <> S.replace_first(t, b, y) : List<&2, Nat>}
  {==}

# One step either answers `y <> t` or `h <> r`, and `r` is the hypothesis's own
# `replace_first(t, k, y)`: whichever way the decision goes, the answer is one
# element in front of something whose length is the length of `t`. That is a fact
# about the prelude's step alone, so it goes under the reserved namespace -- and
# it is where the induction hypothesis is spent, because the length law is an
# induction on the list and not on the decision.
def Policy.rp_branch_len(b: Bool, h: Nat, y: Nat, t: List<&2, Nat>,
                         r: List<&2, Nat>,
                         e: {P.len(r) == P.len(t) : Nat})
    -> {P.len(P.rp_branch(b, h, y, t, r)) == 1n + P.len(t) : Nat}:
  match b:
    case True{}:
      {==}
    case False{}:
      %e : {1n + P.len(r) == 1n + _ : Nat}
      {==}

# `Nil{}` in, `Nil{}` out: both sides are the length of the empty list.
def L.replace_first_len(xs, k, y):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.rp_branch_len(P.eq(h, k), h, y, t, S.replace_first(t, k, y),
                            L.replace_first_len(t, k, y)) :
          {P.len(P.rp_branch(P.eq(h, k), h, y, t, S.replace_first(t, k, y)))
             == _ : Nat}
      {==}

# Both sides are closed, so both compute: the head matches and comes back as `9n`
# in front of the untouched tail.
def L.replace_first_three():
  {==}

# Both sides are closed: no cell matches, each head survives, and the end of the
# list is `Nil{}` either way.
def L.replace_first_absent():
  {==}
