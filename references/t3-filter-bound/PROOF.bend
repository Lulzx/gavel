import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it, and
# the credit path does not count it, so helpers are free -- but every law below
# has to be reachable without them, which is why none of them cites a law.

# `P.le` is reflexive. Inductive in `a`, and the step case is the recursive
# call: `P.le(1n+p, 1n+p)` steps both sides and computes to `P.le(p, p)`.
def Policy.le_refl(a: Nat) -> {P.le(a, a) == True{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.le_refl(p) : {P.le(p, p) == _ : Bool}
      {==}

# No successor is at most what it succeeds. Inductive in `a`; the step case
# steps one successor off each side and computes to the hypothesis.
def Policy.le_succ_self(a: Nat) -> {P.le(1n + a, a) == False{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.le_succ_self(p) : {P.le(1n + p, p) == _ : Bool}
      {==}

# The step case of `filter_len`, as its own def so that the decision is a
# parameter: a `match` cannot scrutinise a computed value, and `P.le(h, n)` is
# one. `h`, `r` and `c` are erased because they occur only in the return type,
# which is a proposition; what survives is the decision `k` and the induction
# hypothesis `ih`.
def Policy.step(k: Bool, -h: Nat, -r: List<Nat>, -c: Nat, ih: {S.len(r) == c : Nat})
    -> {S.len(P.filter_put(h, r, k)) == P.below_put(c, k) : Nat}:
  match k:
    case True{}:
      %Equal.sym(Nat, S.len(r), c, ih) : {1n + _ == 1n + c : Nat}
      {==}
    case False{}:
      ih

# The count law. The base case is `0n == 0n`. The step case computes both sides
# one turn and hands the decision to `Policy.step`; `n` is used twice live (once
# as the threshold, once by the recursive call) so it is bound `+`.
def L.filter_len(xs, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      +m = n
      Policy.step(P.le(h, m), h, S.filter(t, m), P.below_count(t, m),
                  L.filter_len(t, m))

# Both cons laws are one rewrite. `Equal.sym` is the direction that matters: a
# `%e : P` rewrites the goal's `B` to `e`'s left side, so to replace
# `P.le(h, h)` with `True{}` the term supplied has to have type
# `{True{} == P.le(h, h)}`. Once the decision is a literal, `P.filter_put`
# computes and the two sides are the same term.
def L.filter_keep(h, t):
  %Equal.sym(Bool, P.le(h, h), True{}, Policy.le_refl(h)) : {P.filter_put(h, S.filter(t, h), _) == h <> S.filter(t, h) : List<Nat>}
  {==}

def L.filter_drop(h, y, t, e):
  %Equal.sym(Bool, P.le(y, h), False{}, e) : {P.filter_put(y, S.filter(t, h), _) == S.filter(t, h) : List<Nat>}
  {==}
