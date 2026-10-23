import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: inserting one element adds exactly one occurrence of it, and moves
# nothing else. Both sides depend on the argument, so `insert` cannot satisfy
# this by ignoring `xs` -- but it does not pin *where* the element lands, which
# is what the two-element laws below are for.
law insert_count:
  for +xs: List<&2, Nat>
  for +y: Nat
  for +z: Nat
  {P.count(z, S.insert(xs, y)) == P.ind(P.eq(z, y)) + P.count(z, xs) : Nat}

# LAW: the sort is a permutation of its argument. This is the induction, and its
# step case is the whole task: `isort(h <> t)` is `insert(isort(t), h)`, so the
# count of an insert has to be taken against a list the proof cannot match on,
# and the one element `h` has to be counted at both ends of the sum at once.
law isort_count:
  for +xs: List<&2, Nat>
  for +z: Nat
  {P.count(z, S.isort(xs)) == P.count(z, xs) : Nat}

# LAW: two elements in the wrong order come back swapped. `isort_count` alone is
# satisfied by any permutation of the argument -- reversing it, for one -- so the
# order has to be pinned separately, and a two-element list is where the decision
# `P.le` is a literal the proof can act on.
law isort_swap:
  for +x: Nat
  for +y: Nat
  for e: {P.le(x, y) == False{} : Bool}
  {S.isort(x <> y <> Nil{}) == y <> x <> Nil{} : List<&2, Nat>}

# LAW: and the same two elements in the right order come back unchanged, which is
# the other answer the comparison can give. Without it a sort that always moves
# the second element forward would satisfy everything above.
law isort_keep:
  for +x: Nat
  for +y: Nat
  for e: {P.le(x, y) == True{} : Bool}
  {S.isort(x <> y <> Nil{}) == x <> y <> Nil{} : List<&2, Nat>}

# LAW: a number at most the head goes in front of it. The four laws above say
# that `insert` and `isort` keep every count and that `isort` orders a list of
# two, and nothing about a list of three: **measured** by `tools/holes.py`, the
# shipped mutant `isort-tail-not-sorted` -- `insert(t, h)`, inserting the head
# into the *unsorted* tail -- keeps every count, orders every pair, and answers
# `[0n, 1n, 0n]` for `[0n, 1n, 0n]`. V2 had read it as killed by the reference
# proof of `isort_count`, which is a fact about that proof's shape. This law and
# the next fix `insert` on every cons; `insert_count` already fixes it on
# `Nil{}`, where the only list holding exactly one `y` is `y <> Nil{}`.
law insert_before:
  for +h: Nat
  for t: List<&2, Nat>
  for +y: Nat
  for e: {P.le(y, h) == True{} : Bool}
  {S.insert(h <> t, y) == y <> h <> t : List<&2, Nat>}

# LAW: a number above the head goes into the rest. The other half of the case
# split on `P.le(y, h)`.
law insert_after:
  for +h: Nat
  for t: List<&2, Nat>
  for +y: Nat
  for e: {P.le(y, h) == False{} : Bool}
  {S.insert(h <> t, y) == h <> S.insert(t, y) : List<&2, Nat>}

# LAW: sorting a cons is inserting its head into the sorted rest. With the two
# laws above this determines `isort` on every list; `isort_count` fixes it on
# `Nil{}`, since a list with no copies of anything is `Nil{}`.
law isort_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.isort(h <> t) == S.insert(S.isort(t), h) : List<&2, Nat>}
