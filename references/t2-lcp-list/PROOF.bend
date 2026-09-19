import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.is_eq` is stuck when its two arguments are the same *variable*: it descends
# on both of them at once, and a variable is not a constructor, so nothing
# reduces. The step law below compares an element with itself and needs `1n`
# there, so this is that lemma. It is stated with `1n` on the left because the
# rewrite below replaces the comparison with `1n`: the annotation is the goal
# with the proof's *right* side marked, and the step puts the left side there.
def Policy.is_eq_self(x: Nat) -> {1n == P.is_eq(x, x) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_eq_self(p) : {1n == _ : Nat}
      {==}

# `Nil{}` is the first case of the walk on `xs`, whatever `ys` is.
def L.lcp_list_nil_left(ys):
  {==}

# The walk on `xs` is stuck at a variable, so this is an induction on it. Both
# cases reduce: the empty list answers `Nil{}` without looking at `ys`, and the
# cons case meets `ys == Nil{}` in the walk's own first case.
def L.lcp_list_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      {==}

# The walk's cons case with both heads distinct variables: the comparison is
# stuck on the two of them, so both sides are the same gate over the same two
# outcomes, one element in front of the same call.
def L.lcp_list_cons_heads(h, k, t, u):
  {==}

# An induction on the list. The empty list is the walk's own first case, and in
# the cons case the hypothesis says the same fact one element along -- the point
# of the law is that nothing is dropped, so it is the hypothesis that carries
# the tail -- and the self-comparison lemma supplies the other half.
def L.lcp_list_self(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Equal.sym(List<&2, Nat>, S.lcp_list(t, t), t, L.lcp_list_self(t)) : {P.gate_list(P.is_eq(h, h), h <> _) == h <> t : List<&2, Nat>}
      %Policy.is_eq_self(h) : {P.gate_list(_, h <> t) == h <> t : List<&2, Nat>}
      {==}

# Both sides are closed, so every match steps: the two lists agree twice and the
# walk stops at the third position with the gate's `Nil{}`.
def L.lcp_list_stops_at_a_mismatch():
  {==}

# Both sides are closed, so every match steps: the first list runs out after two
# positions and the walk's own empty case answers before the second list is
# looked at again.
def L.lcp_list_shorter_runs_out():
  {==}
