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

# The match on `xs` steps on `Nil{}` and answers `True{}` without looking at
# `ys`.
def L.is_prefix_nil(ys):
  {==}

# The match steps on the cons cell and then finds `Nil{}` where it wants a
# second element.
def L.is_prefix_nil_right(h, t):
  {==}

# Both sides are the same `and` of the same comparison and the same recursive
# call.
def L.is_prefix_cons(h, k, t, u):
  {==}

# An induction in `xs`. The step reduces to the head's comparison and the
# tail's prefix test, so the hypothesis replaces the tail test with `True{}` and
# reflexivity replaces the head's comparison; what is left absorbs into `True{}`
# because `and` finds its answer in the first argument.
def L.is_prefix_self(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Bool, S.is_prefix(t, t), True{}, L.is_prefix_self(t)) : {Bool.and(P.eq(h, h), _) == True{} : Bool}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {Bool.and(_, True{}) == True{} : Bool}
      {==}

# An induction in `xs`, and the same two rewrites in the step as above: `append`
# puts the same head in front of the tail's own prefix test, so the hypothesis
# applies to the tail exactly as it stands.
def L.is_prefix_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Bool, S.is_prefix(t, P.append(t, ys)), True{}, L.is_prefix_append(t, ys)) : {Bool.and(P.eq(h, h), _) == True{} : Bool}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {Bool.and(_, True{}) == True{} : Bool}
      {==}
