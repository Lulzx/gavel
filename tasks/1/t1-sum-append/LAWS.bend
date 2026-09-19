import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: summing an append is the sum of the sums.
law sum_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.sum(S.append(xs, ys)) == S.sum(xs) + S.sum(ys) : Nat}

# LAW: a cons cell adds its head to the sum of the rest.
law sum_cons:
  for x: Nat
  for xs: List<Nat>
  {S.sum(x <> xs) == x + S.sum(xs) : Nat}

# LAW: the head of the first list stays at the front. Both laws above are about
# `sum`, and a sum cannot see a permutation, so without this one the set never
# inspects `append`'s order at all: a body that recurses on its own list and
# pushes the head onto the *other* one returns `reverse(xs) <> ys`, keeps every
# element and therefore every sum. This is the law that observes order, and it
# is stated on `append` directly for that reason -- `sum_append` reaches
# `append` only through `sum`, which is the thing that is blind.
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
