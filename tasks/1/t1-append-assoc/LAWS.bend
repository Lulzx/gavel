import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: appending to the empty list on the left returns the other list.
law append_nil_left:
  for xs: List<Nat>
  {S.append(Nil{}, xs) == xs : List<Nat>}

# LAW: appending nothing on the right returns the list unchanged. This is the
# companion that pins `append`: `append_assoc` is satisfied by the projection
# `append(xs, ys) = ys`, and this law is not.
law append_nil:
  for xs: List<Nat>
  {S.append(xs, Nil{}) == xs : List<Nat>}

# LAW: `append` is associative.
law append_assoc:
  for xs: List<Nat>
  for ys: List<Nat>
  for zs: List<Nat>
  {S.append(S.append(xs, ys), zs) == S.append(xs, S.append(ys, zs)) : List<Nat>}
