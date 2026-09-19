import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helper lemmas, in the reserved `Policy.` namespace so the laws stay readable.

# `eq` steps one successor off both of its arguments at once, so `eq(x, x)` on a
# variable `x` is stuck: this is an induction in `x`, and the step recurses on
# the predecessor.
def Policy.eq_refl(x: Nat) -> {P.eq(x, x) == True{} : Bool}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Bool, P.eq(p, p), True{}, Policy.eq_refl(p)) : {_ == True{} : Bool}
      {==}

# `Bool.or` matches on its first argument, so `or(a, True{})` at a variable `a`
# is stuck as well; this is the induction in `a`.
def Policy.or_true_right(a: Bool) -> {Bool.or(a, True{}) == True{} : Bool}:
  match a:
    case True{}:
      {==}
    case False{}:
      {==}

# `eq_list` steps one cons cell off both of its arguments at once, so here the
# step needs both halves of the cell to be equal to themselves.
def Policy.eq_list_refl(+xs: List<&2, Nat>) -> {P.eq_list(xs, xs) == True{} : Bool}:
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Equal.sym(Bool, P.eq_list(t, t), True{}, Policy.eq_list_refl(t)) : {Bool.and(P.eq(h, h), _) == True{} : Bool}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {Bool.and(_, True{}) == True{} : Bool}
      {==}

# The laws.

# The match on `ys` reaches `Nil{}` immediately, so the body answers `is_nil` of
# `xs`; for a cons cell `k <> u` the first disjunct is `False{}` at `Nil{}` and
# what is left is the hypothesis at `u`.
def L.is_suffix_nil(ys):
  match ys:
    case Nil{}:
      {==}
    case k <> +u:
      %Equal.sym(Bool, S.is_suffix(Nil{}, u), True{}, L.is_suffix_nil(u)) : {_ == True{} : Bool}
      {==}

# The match steps on the cons cell and finds `Nil{}` where it wants `ys` to
# continue.
def L.is_suffix_nil_right(h, t):
  {==}

# Both sides are the same `or` of the same comparison and the same recursive
# call.
def L.is_suffix_cons(xs, k, u):
  {==}

# Every list is a suffix of itself, by induction on the list. The step offers
# the whole of `h <> t` against the front of `h <> t` and then steps past the
# head; the first offer succeeds, so the walk never has to look further.
def L.is_suffix_self(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Equal.sym(Bool, P.eq_list(h <> t, h <> t), True{}, Policy.eq_list_refl(h <> t)) : {Bool.or(_, S.is_suffix(h <> t, t)) == True{} : Bool}
      {==}

# An induction in `ys`. `append` puts `xs` at the front, so in the step the
# second list is `k` followed by the tail's own append: the first disjunct asks
# whether `xs` is that whole list, and the hypothesis answers the second. When
# `ys` is empty `append` yields `xs` itself, and the fact that a list is a
# suffix of itself is what the previous law proves.
def L.is_suffix_append(xs, ys):
  match ys:
    case Nil{}:
      %Equal.sym(Bool, S.is_suffix(xs, xs), True{}, L.is_suffix_self(xs)) : {_ == True{} : Bool}
      {==}
    case k <> +u:
      %Equal.sym(Bool, S.is_suffix(xs, P.append(u, xs)), True{}, L.is_suffix_append(xs, u)) : {Bool.or(P.eq_list(xs, k <> P.append(u, xs)), _) == True{} : Bool}
      %Equal.sym(Bool, Bool.or(P.eq_list(xs, k <> P.append(u, xs)), True{}), True{}, Policy.or_true_right(P.eq_list(xs, k <> P.append(u, xs)))) : {_ == True{} : Bool}
      {==}
