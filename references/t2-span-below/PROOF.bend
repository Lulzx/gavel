import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the body reduces on it and both sides are
# the empty pair.
def L.span_below_nil(n):
  {==}

# The premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
# predicate sits, so the step is the premise turned round by `Equal.sym`. With
# the decision a literal, `P.span_put` answers with the head on the front of the
# tail's pair and the tail's back, and the goal is an identity.
def L.span_below_keep(h, t, n, e):
  %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.span_put(h, t, S.span_below(t, n), _) == P.MkL{h <> P.front(S.span_below(t, n)), P.back(S.span_below(t, n))} : P.PairL}
  {==}

# The same rewrite with the other literal. The helper answers the empty pair
# with the whole list as its back, which is the law's right-hand side, and the
# tail's pair is never read.
def L.span_below_stop(y, t, n, e):
  %Equal.sym(Bool, P.le(y, n), False{}, e) : {P.span_put(y, t, S.span_below(t, n), _) == P.MkL{Nil{}, y <> t} : P.PairL}
  {==}

# What the cons step does to the pair's two lengths. It is a `match` on the
# decision, which is an *argument* here, so the two answers are the two branches
# and each is its own arithmetic. On the passing branch the goal is about
# `P.span_put(h, t, p, True{})`, whose front is `h <> P.front(p)`, so the left
# side is `1n + P.len(P.front(p))` against the back's length, and the
# hypothesis -- the two lengths of `p` -- has to be carried through the `1n +`
# that is now outside them. On the failing branch nothing about `p` is left in
# the goal at all: the left side is the length of `h <> t` and the right side is
# the same term, so `{==}` closes it.
def Policy.span_step_len(h: Nat, t: List<&2, Nat>, p: P.PairL, k: Bool,
                         ih: {P.len(P.front(p)) + P.len(P.back(p)) == P.len(t) : Nat})
    -> {P.len(P.front(P.span_put(h, t, p, k))) + P.len(P.back(P.span_put(h, t, p, k))) == 1n + P.len(t) : Nat}:
  match k:
    case True{}:
      %ih : {1n + (P.len(P.front(p)) + P.len(P.back(p))) == 1n + _ : Nat}
      {==}
    case False{}:
      {==}

# The length law is an induction on `xs`, and the step is exactly the helper
# above with the hypothesis for the tail and the decision `P.le(h, n)`. The
# helper takes the hypothesis as an *argument* rather than being written out
# twice because the two branches of the decision need different things from it,
# and only a `match` on an argument can tell them apart.
def L.span_below_len(xs, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.span_step_len(h, t, S.span_below(t, n), P.le(h, n), L.span_below_len(t, n))
