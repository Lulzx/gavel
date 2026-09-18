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
