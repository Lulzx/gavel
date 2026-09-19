import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `eq` steps one successor off both of its arguments at once, so `eq(x, x)` on
# a variable `x` is stuck: this is an induction in `x`, and the step recurses on
# the predecessor. `True{}` has to be written on the left for the rewrite
# below, since what the goal carries is the `eq` and not the `True{}`.
def Policy.eq_refl(x: Nat) -> {P.eq(x, x) == True{} : Bool}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Bool, P.eq(p, p), True{}, Policy.eq_refl(p)) : {_ == True{} : Bool}
      {==}

# The match on `xs` steps on `Nil{}` and answers `0n` without looking at `ys`.
def L.count_matches_nil(ys):
  {==}

# The match steps on the cons cell and then finds `Nil{}` where it wants a
# second element.
def L.count_matches_nil_right(h, t):
  {==}

# Both sides are the same weight over the same comparison and the same
# recursive call.
def L.count_matches_cons(h, k, t, u):
  {==}

# An induction in `xs`. The step reduces to the head's weight plus the tail's
# count against the length of the same tail, so the hypothesis replaces the
# tail's count with its length and reflexivity replaces the head's comparison
# with `True{}`; `pick` then finds its answer in the first argument, and both
# sides are `1n + len(t)`.
def L.count_matches_self(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, S.count_matches(t, t), P.len(t), L.count_matches_self(t)) : {P.pick(P.eq(h, h), 1n, 0n) + _ == 1n + P.len(t) : Nat}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {P.pick(_, 1n, 0n) + P.len(t) == 1n + P.len(t) : Nat}
      {==}
