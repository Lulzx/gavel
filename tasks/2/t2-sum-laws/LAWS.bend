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
