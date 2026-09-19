import Base
import ./prelude.bend as P
import ./solution.bend as S

# The matrix is `List<&2, List<&2, Nat>>` throughout, so every law that states
# an equality of matrices spells that type out. The one law whose right-hand
# side is a value the policy does not compute is `transpose_single_row`: it is
# stated against the prelude's `singletons`, which is the shape the answer has
# to have, not the answer restated.

# LAW: the empty matrix transposes to the empty matrix. The left-hand side is a
# ground term and both sides compute, so this is definitional: it fixes the
# answer the recursion reaches when there is nothing left to insert, and a body
# that answered a column there would satisfy `transpose_cons` at every non-empty
# matrix. An empty case is an answer a stopped match gives rather than a step,
# so nothing else in this file looks at it.
law transpose_nil:
  {S.transpose(Nil{}) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the step of the transpose, written out. Both sides compute -- the left
# by unfolding `transpose`, the right by the recursion on `rs` -- so this is
# definitional, and it is what fixes the shape of the answer: a body that
# dropped the first row, or that inserted it into the wrong place, leaves the
# two sides unconvertible. It names both policy functions, so it is also the law
# that says the two of them have to agree about which row goes where.
law transpose_cons:
  for r: List<&2, Nat>
  for rs: List<&2, List<&2, Nat>>
  {S.transpose(r <> rs) == S.insert_row(r, S.transpose(rs)) : List<&2, List<&2, Nat>>}

# LAW: transposing a one-row matrix gives one one-element column per element of
# the row. This is the law that names `transpose` on the left and a value the
# policy does not compute on the right, so it is what keeps the function honest
# against a cancelling wrapper: a body of the form `wrap(transpose(rows))` with
# `wrap` cancelling along a fold satisfies every law that names the target on
# both sides, and does not satisfy this one. It is also the law that is not
# definitional: with the row a variable, neither side reduces, so it is the one
# law here that an induction has to close.
law transpose_single_row:
  for r: List<&2, Nat>
  {S.transpose(r <> Nil{}) == P.singletons(r) : List<&2, List<&2, Nat>>}

# LAW: inserting a row into no columns starts one column per element of the row.
# The left-hand side is a ground term in its second argument and both sides
# compute, so this is definitional, and it is the base case of `insert_row`:
# a body that answered something else when there are no columns to fill would
# satisfy `insert_row_cons_cols` at every non-empty `cols`.
law insert_row_nil:
  for cols: List<&2, List<&2, Nat>>
  {S.insert_row(Nil{}, cols) == cols : List<&2, List<&2, Nat>>}

# LAW: a row that has run out leaves the columns it was inserted into alone, and
# an element whose column has run out starts a new one-element column. Both
# sides compute, so this is the pair of definitional equations for the two ways
# `insert_row` can stop, and it is what fixes the *length* of the result: a body
# that dropped the leftover elements, or that kept them in place, does not have
# these two sides equal.
law insert_row_empty_cols:
  for h: Nat
  for t: List<&2, Nat>
  {S.insert_row(h <> t, Nil{}) == (h <> Nil{}) <> S.insert_row(t, Nil{}) : List<&2, List<&2, Nat>>}

# LAW: the step of the insertion. The head of the row goes on the front of the
# first column, and the rest of the row goes into the rest of the columns. Both
# sides compute, so this is definitional, and it is the law that fixes the
# *order*: a body that consed the row's elements onto the wrong columns, or that
# reversed them, leaves the two sides unconvertible.
law insert_row_cons_cols:
  for h: Nat
  for t: List<&2, Nat>
  for c: List<&2, Nat>
  for cs: List<&2, List<&2, Nat>>
  {S.insert_row(h <> t, c <> cs) == (h <> c) <> S.insert_row(t, cs) : List<&2, List<&2, Nat>>}

# LAW: a concrete two-by-two matrix transposes to the matrix with its rows and
# columns exchanged. Both sides compute, so this is definitional, and it is the
# one law here that pins a *placement* end to end: the laws above say how each
# step works, and this one says the steps add up to the answer a reader can
# check by eye.
law transpose_two_by_two:
  {S.transpose((1n <> (2n <> Nil{})) <> ((3n <> (4n <> Nil{})) <> Nil{}))
     == (1n <> (3n <> Nil{})) <> ((2n <> (4n <> Nil{})) <> Nil{}) : List<&2, List<&2, Nat>>}
