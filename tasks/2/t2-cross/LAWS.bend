import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are the specification of `cross`. The product is read row by row:
# `cross(x <> t, ys)` is the row for `x` -- `x` paired with every element of
# `ys`, in the order `ys` has them -- followed by the product of the rest of
# `xs` with `ys`. The empty list of rows is the product of nothing, so `cross`
# answers `Nil{}` on an empty `xs` and a row answers `Nil{}` on an empty `ys`.
# Together the second and fourth laws below unfold both functions at every
# input, and the empty list is reached from every input by the recursions they
# describe; the remaining laws are consequences of those unfoldings, stated
# because a body can agree with the steps and still be wrong at one of them.

# The anchor at the bottom: no element of `xs` means no row, whatever `ys` is.
# The right-hand side calls no target.
law cross_nil:
  for ys: List<&2, Nat>
  {S.cross(Nil{}, ys) == Nil{} : List<&2, P.Pair>}

# The anchor for a single row: no element of `ys` means no cell, whatever `x`
# is. The right-hand side calls no target.
law row_nil:
  for x: Nat
  {S.row(x, Nil{}) == Nil{} : List<&2, P.Pair>}

# The row's step, and the law that says what a row is. The element at the front
# of `ys` is paired with `x` and put in front of the row for the tail, so the
# pairs come out in the order `ys` has them -- not reversed, and not paired
# the other way round. A body that built `P.MkPair{y, x}`, or that recursed on
# `ys` without moving along it, has a different unfolding here.
law row_cons:
  for +x: Nat
  for +y: Nat
  for t: List<&2, Nat>
  {S.row(x, y <> t) == P.MkPair{x, y} <> S.row(x, t) : List<&2, P.Pair>}

# The product's step, and the hand-off from the rows to the whole list. The row
# for the front element comes first and the product of the tail comes after it,
# so the answer is in the order `xs` has them; and the whole of `ys` is handed
# to every row. A body that put the tail's product first, or that dropped the
# front row, or that answered the pairs in one flat walk with the two indices
# the other way round, has a different unfolding here.
law cross_cons:
  for +x: Nat
  for +t: List<&2, Nat>
  for +ys: List<&2, Nat>
  {S.cross(x <> t, ys) == P.append(S.row(x, ys), S.cross(t, ys)) : List<&2, P.Pair>}

# Content, at a list of exactly one element: the product of a one-row `xs` is
# that row and nothing else, so a body that padded the answer with an empty row
# at the end, or that appended one row too many, is separated here. The two
# sides are the same list because a concatenation with nothing on its right
# changes nothing -- which is a fact about `P.append`, not about `cross`.
law cross_one:
  for +x: Nat
  for ys: List<&2, Nat>
  {S.cross(x <> Nil{}, ys) == S.row(x, ys) : List<&2, P.Pair>}

# Content, at a closed product. Every cell is named: two rows of two, the first
# row before the second, and inside a row the pairs in the order the second list
# has them. A body that transposed the product, that reversed a row, or that
# paired the wrong elements together is separated here, and this is the one law
# whose left-hand side is a ground term.
law cross_two_two:
  {S.cross(1n <> (2n <> Nil{}), 3n <> (4n <> Nil{}))
     == P.MkPair{1n, 3n} <> (P.MkPair{1n, 4n} <> (P.MkPair{2n, 3n} <> (P.MkPair{2n, 4n} <> Nil{})))
     : List<&2, P.Pair>}
