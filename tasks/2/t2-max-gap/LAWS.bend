import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a list with no elements has no neighbouring pair, so the largest distance
# over it is `0n`. Both sides compute, so this is definitional, and it is an
# absolute anchor: the right-hand side calls neither target. It is also the only
# law here that reaches `Nil{}` through `max_gap` itself, so a body that answered
# anything else there -- or a body built as `c + ref(xs)` with a constant that
# cancels out of every law about the walk -- is caught here.
law max_gap_nil:
  {S.max_gap(Nil{}) == 0n : Nat}

# LAW: one element has no *neighbour*, so the answer is `0n` and not the element
# itself. Both sides compute, and the right-hand side calls no target. This is
# the law that separates the reading which starts `best` at the first element --
# or which answers the largest element when there is no pair at all -- from the
# walk here, which starts at `0n` and never looks at the first element alone.
law max_gap_single:
  for x: Nat
  {S.max_gap(x <> Nil{}) == 0n : Nat}

# LAW: the opening step. A list with two or more elements hands the walk its
# tail, the element *before* that tail's first window, and `0n` as the largest
# distance seen so far. Both sides compute, so this is definitional, and it is
# what says the first element is never paired with anything before it: a body
# that opened the walk with the head as `best` is separated here.
law max_gap_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.max_gap(h <> t) == S.gap_go(t, h, 0n) : Nat}

# LAW: the walk's empty case answers the largest distance it was carrying,
# whatever that is and whatever element came before it. Both sides compute, and
# the right-hand side calls no target: it is the anchor for the walk. A body that
# answered `0n` there, or the last distance instead of the largest, keeps every
# law above and is separated here.
law gap_go_nil:
  for prev: Nat
  for best: Nat
  {S.gap_go(Nil{}, prev, best) == best : Nat}

# LAW: the walk's step. The head is measured against the element before the
# window, that distance and the largest seen so far are folded with `Nat.max`,
# and the walk continues with the head as the element before the next window.
# Both sides compute, so this is definitional, and it is the law that says
# *which* number comes out: a body folded with `Nat.min`, or one that kept only
# the distance of the pair it is looking at, is separated here. The element
# before and the largest-so-far are universally quantified, so the law holds at
# every window the walk can be in.
law gap_go_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for prev: Nat
  for best: Nat
  {S.gap_go(h <> t, prev, best) == S.gap_go(t, h, Nat.max(P.absdiff(prev, h), best)) : Nat}

# LAW: a run of equal elements has a distance of `0n` at every window, so the
# walk over it answers exactly what it was carrying. This is the law that is not
# definitional, and it is the induction: `gap_go` is stuck on `P.same(n, k)` at a
# variable `n`, and `P.absdiff(k, k)` does not reduce on a variable either, so
# neither side is a computation -- only the fact that a number is at distance
# `0n` from itself, and that `0n` is the identity of `Nat.max`, collapses the two.
# It is what says the answer is a *largest* over a walk rather than a count of
# windows: a body that added the distances up would grow with the run and fail
# here while keeping every law above.
law gap_go_same:
  for +n: Nat
  for +k: Nat
  for +best: Nat
  {S.gap_go(P.same(n, k), k, best) == best : Nat}

# LAW: one closed list, read end to end. The gaps are `8n` and `7n`, so the
# answer is the first of them, and a body that answered the *last* distance, or
# the smallest, satisfies every law above and is separated here.
law max_gap_three:
  {S.max_gap(1n <> (9n <> (2n <> Nil{}))) == 8n : Nat}
