import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so
# both sides reduce to the default by unfolding alone.
def L.nth_from_end_nil(k, d):
  {==}

# `h <> t` is a cons cell, so the match takes its cons case and both sides
# reduce to the same decision on the length of the tail.
def L.nth_from_end_step(h, t, k, d):
  {==}

# Both sides are closed in shape: the walk takes its cons case, the tail is one
# element long, and the comparison against `0n` decides `False{}` by unfolding,
# so the walk recurses to a one-element list and answers its head there.
def L.nth_from_end_pair_last(x, y, d):
  {==}

# The same list asked for `1n`: the comparison against `1n` decides `True{}` at
# the outer step, so the answer is the head.
def L.nth_from_end_pair_first(x, y, d):
  {==}

# The same reduction one step longer: the outer tail holds two elements and the
# comparison against `2n` decides `True{}` there.
def L.nth_from_end_third(x, y, z, d):
  {==}

# `snoc` of a list of length `a` appends one element, so the walk's test on
# `P.snoc(a, x)` is `1n + P.len(a)` against the distance. This is the lemma the
# induction below needs, and it is about the prelude's own functions rather than
# about the policy, so it lives under the reserved namespace.
def Policy.len_snoc(a: List<&2, Nat>, x: Nat) -> {P.len(P.snoc(a, x)) == 1n + P.len(a) : Nat}:
  match a:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.snoc(t, x)), 1n + P.len(t), Policy.len_snoc(t, x)) : {1n + _ == 1n + (1n + P.len(t)) : Nat}
      {==}

# The last element of a list of `1n + n` elements. Inductive in the length of the
# run of equal elements. Each step appends its head in front of `P.snoc` of the
# shorter run, so the walk sees a cons cell whose tail is one longer than the
# distance `0n` -- `len_snoc` says so -- and the comparison against `0n` is
# `1n + P.len(...)` against `0n`, a successor against `0n`, which decides
# `False{}` by unfolding. The head is not the answer and the walk recurses; what
# is left is the hypothesis at the shorter run.
def L.nth_from_end_last(n, x, y, d):
  match n:
    case 0n:
      {==}
    case 1n+p:
      +rp = p
      +rx = x
      +ry = y
      +rd = d
      %Equal.sym(Nat, P.len(P.snoc(P.same(rp, rx), ry)), 1n + P.len(P.same(rp, rx)), Policy.len_snoc(P.same(rp, rx), ry)) : {P.pick_if(P.eq(_, 0n), rx, S.nth_from_end(P.snoc(P.same(rp, rx), ry), 0n, rd)) == ry : Nat}
      %L.nth_from_end_last(rp, rx, ry, rd) : {S.nth_from_end(P.snoc(P.same(rp, rx), ry), 0n, rd) == _ : Nat}
      {==}

# Both sides are closed, so the walk reduces end to end: `[1n, 2n]` has a
# two-element list at its first step, then a one-element one, then the empty
# list. The comparisons are `1n` against `2n` and `0n` against `2n`, so the empty
# arm is reached and what is left is the default against itself.
def L.nth_from_end_out():
  {==}
