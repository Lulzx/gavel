import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: appending the empty list on the left changes nothing.
law append_nil_left:
  for xs: List<Nat>
  {S.append(Nil{}, xs) == xs : List<Nat>}

# LAW: the length of an append is the sum of the lengths.
law len_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.len(S.append(xs, ys)) == S.add(S.len(xs), S.len(ys)) : Nat}
