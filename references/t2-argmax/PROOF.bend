import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the match in `argmax` takes its empty case
# and both sides are zero.
def L.argmax_nil():
  {==}

# `h <> t` is a cons cell, so the outer match takes its cons case and hands the
# tail, the head, the position `0n` and the counter `1n` to the walk.
def L.argmax_cons(h, t):
  {==}

# The walk's empty case is the position of the largest element it has seen.
def L.argmax_go_nil(cur, bi, i):
  {==}

# The walk's cons case folds the head into both running values and recurses on
# the tail, taking the position on a strict win only.
def L.argmax_go_step(h, t, cur, bi, i):
  {==}

# Both sides are closed, so both matches reduce: the walk starts at `1n` with
# `0n` as the position of `1n`, `3n` beats it, and `2n` does not beat `3n`. What
# is left is `1n` against `1n`.
def L.argmax_three():
  {==}

# Both sides are closed again, and this time the largest element occurs twice:
# the walk reaches `3n` at position `1n` and then meets a second `3n` at `2n`,
# which does not beat the first, so the position stays at `1n`.
def L.argmax_tie():
  {==}

# `gt` steps one successor off both of its arguments at once, so with the
# argument it is handed twice it never gets off the ground: `gt(k, k)` is stuck
# where it is written, and this is the lemma that says it is `False{}` at every
# `k`. It is under the reserved `Policy.*` namespace because it is about the
# prelude's comparison rather than about the policy's walk.
def Policy.gt_irrefl(k: Nat) -> {P.gt(k, k) == False{} : Bool}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      %Policy.gt_irrefl(p) : {P.gt(p, p) == _ : Bool}
      {==}

# `max2` of a number with itself is that number: the two arguments step off
# together, so the recursion is on the predecessor and the answer is a successor
# of it.
def Policy.max2_self(k: Nat) -> {P.max2(k, k) == k : Nat}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.max2(p, p), p, Policy.max2_self(p)) : {1n + _ == 1n + p : Nat}
      {==}

# The walk over a list of equal elements, from a state whose largest seen so far
# is that element: the position it started from, whatever the counter reads.
# Inductive in the length of the list. Each element ties with the largest seen
# so far, so the comparison is settled by `gt_irrefl` -- which is flipped,
# because the goal has the term being rewritten on the left -- and the largest
# seen so far is settled by `max2_self`; the decision on `False{}` then unfolds
# to the position the walk started from, and what is left is the hypothesis at
# the predecessor, with the counter one along.
#
# The element is rebound reusable first (`+r = k`): a law def's parameters are
# good for one live use each, and the element is cited by both lemmas and by the
# hypothesis. The rebound name carries those uses instead, so `k` itself is read
# once.
def L.argmax_same(n, k, bi, i):
  match n:
    case 0n:
      {==}
    case 1n+p:
      +r = k
      %Equal.sym(Nat, P.max2(r, r), r, Policy.max2_self(r)) : {S.argmax_go(P.same(p, k), _, P.pick_if(P.gt(k, k), i, bi), 1n + i) == bi : Nat}
      %Equal.sym(Bool, P.gt(r, r), False{}, Policy.gt_irrefl(r)) : {S.argmax_go(P.same(p, k), k, P.pick_if(_, i, bi), 1n + i) == bi : Nat}
      %Equal.sym(Nat, S.argmax_go(P.same(p, k), k, bi, 1n + i), bi, L.argmax_same(p, r, bi, 1n + i)) : {_ == bi : Nat}
      {==}
