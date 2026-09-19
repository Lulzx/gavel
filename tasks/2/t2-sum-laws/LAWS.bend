import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the sum of an append is the sum of the sums. With a real `sum` this is
# what pins `append`: only an `append` that really concatenates keeps the total
# on the left unchanged.
law sum_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.sum(S.append(xs, ys)) == S.sum(xs) + S.sum(ys) : Nat}

# LAW: the sum of a one-element list is that element. This is the law that pins
# `sum`: `sum_append` is satisfied by a `sum` that ignored its argument entirely
# and returned `0n`, because then both sides are `0n`.
law sum_single:
  for h: Nat
  {S.sum(h <> Nil{}) == h : Nat}

# LAW: the head of the first list stays at the front. `sum_append` is about
# `sum`, and a sum cannot see a permutation, so without an order law the set
# never inspects `append`: a body that recurses on its own list and pushes the
# head onto the *other* one returns `reverse(xs) <> ys`, keeps every element and
# therefore every sum. This is the law that observes order, stated on `append`
# directly for that reason. The identical pair closes `t1-sum-append` (Fact 38).
law append_cons:
  for h: Nat
  for t: List<Nat>
  for ys: List<Nat>
  {S.append(h <> t, ys) == h <> S.append(t, ys) : List<Nat>}

# LAW: the empty list is the left identity. `append_cons` alone leaves
# `append(Nil{}, ys)` free in *content*: `sum_append` fixes only the sum of the
# answer, so a permutation of `ys` passes it and `append_cons` both. This law is
# what makes the base a value rather than a number.
law append_nil_left:
  for ys: List<Nat>
  {S.append(Nil{}, ys) == ys : List<Nat>}
