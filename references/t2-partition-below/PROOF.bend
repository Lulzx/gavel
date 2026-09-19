import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the body reduces on it and both sides are
# the empty pair.
def L.partition_below_nil(n):
  {==}

# The premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
# predicate sits, so the step is the premise turned round by `Equal.sym`. With
# the decision a literal, `P.part_put` answers with the head on the front of the
# tail's pair and the tail's back, and the goal is an identity.
def L.partition_below_keep(h, t, n, e):
  %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.part_put(h, S.partition_below(t, n), _) == P.MkL{h <> P.front(S.partition_below(t, n)), P.back(S.partition_below(t, n))} : P.PairL}
  {==}

# The same rewrite with the other literal. This is the branch where the head
# joins the *back* and the front is the tail's front, which is the law's
# right-hand side.
def L.partition_below_drop(y, t, n, e):
  %Equal.sym(Bool, P.le(y, n), False{}, e) : {P.part_put(y, S.partition_below(t, n), _) == P.MkL{P.front(S.partition_below(t, n)), y <> P.back(S.partition_below(t, n))} : P.PairL}
  {==}

# `a + (1n + b) == 1n + (a + b)`. This is a fact about `Nat`'s addition that the
# prelude does not have, and no law covers, so it is a lemma of its own -- the
# gate ignores the reserved namespace and this one cites no law. It is an
# induction on `a`: at `0n` both sides reduce to `1n + b`, and at `1n+p` the
# successor comes off each side, which leaves the hypothesis on `p`.
def Policy.add_succ_right(a: Nat, b: Nat) -> {a + (1n + b) == 1n + (a + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ_right(p, b) : {1n + (p + (1n + b)) == 1n + _ : Nat}
      {==}

# What the cons step does to the pair's two lengths. It is a `match` on the
# decision, which is an *argument* here, so the two answers are the two branches
# and each is its own arithmetic. The pair is `+p` because the rejecting branch
# names both projections twice -- once in the reassociation step and once in the
# hypothesis rewrite -- and a plain parameter may be read once.
#
# On the passing branch the goal is about `P.part_put(h, p, True{})`, whose
# front is `h <> P.front(p)`, so the left side is `1n + P.len(P.front(p))`
# against the back's length, and the hypothesis -- the two lengths of `p` -- has
# to be carried through the `1n +` that is now outside them.
#
# On the rejecting branch the head goes on the *back*, so the left side is
# `P.len(P.front(p)) + (1n + P.len(P.back(p)))` and it does not reduce: `+`
# matches on its left argument and that is `P.len(P.front(p))`, which is stuck.
# The reassociation lemma moves the `1n +` outside, and then the hypothesis
# closes it.
def Policy.part_step_len(h: Nat, t: List<&2, Nat>, +p: P.PairL, k: Bool,
                         ih: {P.len(P.front(p)) + P.len(P.back(p)) == P.len(t) : Nat})
    -> {P.len(P.front(P.part_put(h, p, k))) + P.len(P.back(P.part_put(h, p, k))) == 1n + P.len(t) : Nat}:
  match k:
    case True{}:
      %ih : {1n + (P.len(P.front(p)) + P.len(P.back(p))) == 1n + _ : Nat}
      {==}
    case False{}:
      %Equal.sym(Nat, P.len(P.front(p)) + (1n + P.len(P.back(p))), 1n + (P.len(P.front(p)) + P.len(P.back(p))), Policy.add_succ_right(P.len(P.front(p)), P.len(P.back(p)))) : {_ == 1n + P.len(t) : Nat}
      %ih : {1n + (P.len(P.front(p)) + P.len(P.back(p))) == 1n + _ : Nat}
      {==}

# The length law is an induction on `xs`, and the step is exactly the helper
# above with the hypothesis for the tail and the decision `P.le(h, n)`. The
# helper takes the hypothesis as an *argument* rather than being written out
# twice because the two branches of the decision need different things from it,
# and only a `match` on an argument can tell them apart.
def L.partition_below_len(xs, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.part_step_len(h, t, S.partition_below(t, n), P.le(h, n), L.partition_below_len(t, n))
