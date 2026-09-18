import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: appending the empty list on the right changes nothing.
law append_nil:
  for xs: List<Nat>
  {S.append(xs, Nil{}) == xs : List<Nat>}
