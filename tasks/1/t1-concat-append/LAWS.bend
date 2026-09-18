import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: concatenating a list of lists that ends in one more list is the same as
# appending that list to the concatenation. `append_ll` matches on its first
# argument, so with a variable `xss` the goal does not reduce on its own: this
# one is inductive in `xss`.
#
# This law pins `concat` on its own. The only body that ignores `xss` is
# `Nil{}`, and then the left-hand side is `Nil{}` while the right-hand side is
# `append(Nil{}, ys)`, i.e. `ys` -- which differs for a variable `ys`. It also
# fixes the order: a `concat` that flattens the outer list backwards is not
# `append(concat(xss), ys)` either.
law concat_append:
  for xss: List<&2, List<&2, Nat>>
  for ys: List<&2, Nat>
  {S.concat(P.append_ll(xss, ys)) == P.append(S.concat(xss), ys) : List<&2, Nat>}
