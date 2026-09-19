import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is the outer match's first case, on both sides.
def L.max_gap_nil():
  {==}

# `x <> Nil{}` opens the walk on an empty tail, whose empty case answers what it
# was carrying -- `0n`.
def L.max_gap_single(x):
  {==}

# Both sides are the walk opened on the same tail with the same element before
# it and nothing seen yet.
def L.max_gap_cons(h, t):
  {==}

# The walk's empty case answers the largest distance it was carrying, whatever
# the element before the window was.
def L.gap_go_nil(prev, best):
  {==}

# Both sides reduce to the same `Nat.max` on the same distance and the same
# largest-so-far, and then to the same walk.
def L.gap_go_cons(h, t, prev, best):
  {==}

# Both sides are closed: the walk steps over `9n` and `2n` and the larger of `8n`
# and `7n` is what is left on either side.
def L.max_gap_three():
  {==}

# `P.absdiff` steps one successor off each side at once, so `P.absdiff(a, a)` is
# stuck on a variable `a` and the distance of a number from itself is not
# definitional: it is an induction on `a`, which is what the law about a run of
# equal elements needs. The statement is oriented with `0n` on the left because a
# rewrite step replaces the side the hole in the pattern stands for.
def Policy.absdiff_self(a: Nat) -> {0n == P.absdiff(a, a) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.absdiff_self(p) : {0n == _ : Nat}
      {==}

# `Nat.max` steps one successor off each side at once too, so with `0n` on the
# left it steps on the right argument alone: the largest of `0n` and a number is
# that number, which is what makes `0n` the identity of `Nat.max` here.
def Policy.max_zero_left(m: Nat) -> {m == Nat.max(0n, m) : Nat}:
  match m:
    case 0n:
      {==}
    case 1n+q:
      {==}

# The walk over `P.same(n, k)` is stuck at a variable `n`, so the two sides are
# not the same unfolding. At `1n+p` the list opens to `k <> same(p, k)` and the
# step leaves `P.absdiff(k, k)` inside a `Nat.max`: the first lemma rewrites that
# distance to `0n`, the second removes `0n` from the `Nat.max`, and what is left
# is the walk over the shorter run, which is the induction hypothesis.
def L.gap_go_same(n, k, best):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Policy.absdiff_self(k) :
          {S.gap_go(P.same(p, k), k, Nat.max(_, best)) == best : Nat}
      %Policy.max_zero_left(best) :
          {S.gap_go(P.same(p, k), k, _) == best : Nat}
      %L.gap_go_same(p, k, best) :
          {S.gap_go(P.same(p, k), k, best) == _ : Nat}
      {==}
