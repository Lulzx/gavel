import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the sum of an append is the sum of the sums.
law sum_append:
  for xs: List<&2, Nat>
  for ys: List<&2, Nat>
  {S.sum(S.append(xs, ys)) == S.add(S.sum(xs), S.sum(ys)) : Nat}

# LAW: the sum of a one-element list is that element.
law sum_single:
  for h: Nat
  {S.sum(h <> Nil{}) == h : Nat}
