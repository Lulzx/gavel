Implement `insert_row` and `transpose`, the two halves of matrix transposition,
then prove the laws that pin them.

A matrix here is `List<&2, List<&2, Nat>>`: a list of rows, where each row is a
list of `Nat`. The transpose of a matrix is the matrix whose first row is the
first column of the original and whose second row is the second column, and so
on: the rows and the columns have been exchanged.

`insert_row(r, cols)` conses the elements of `r` onto the front of the columns
in `cols`, in order. Recurse on `r`: when `r` is empty, `cols` is the answer,
because a row with nothing left in it asks nothing more of the columns it was
inserted into. When `r` is `h <> t`, the head goes on the front of the first
column of `cols` if there is one, and an element whose column does not exist yet
starts a new one-element column, because that element is the first thing in a
column no earlier row had reached.

`transpose(rows)` must return the transpose. Recurse on `rows`: the empty matrix
transposes to the empty matrix, and a matrix whose first row is `r` and whose
rest is `rs` transposes by inserting `r` into the transpose of `rs` -- the first
row is one element of every column of the answer, so it is the row that has to
be inserted into the already-transposed rest.

The law `transpose_nil` fixes the answer the recursion reaches on the empty
matrix. It is the weak companion that pins the base case: `transpose_cons` says
what a non-empty matrix answers in terms of its tail, so a body that got the
empty matrix wrong still satisfies it.

The law `transpose_cons` is the step, written out. It is definitional -- both
sides unfold, the left through the recursion and the right through the insertion
-- and it is the law that says the two functions you write have to agree about
which row goes where.

The law `transpose_single_row` is the one law whose right-hand side is a value
you do not compute. `singletons(r)` is the prelude's one-row matrix built one
column at a time, so the law says that transposing a matrix with a single row
gives that. `transpose_cons` alone is satisfied by a wrapper that cancels along
the fold, and this law is not, which is why it is here.

The laws `insert_row_nil`, `insert_row_empty_cols` and `insert_row_cons_cols`
are the definition of the insertion, one equation per way it can stop and one
for the step. `insert_row_nil` fixes the answer when there are no columns to
fill, `insert_row_empty_cols` fixes what happens when the row runs out before
the columns do -- and what happens when a column runs out before the row does,
which is where the new one-element column comes from -- and
`insert_row_cons_cols` fixes the order: the row's head goes on the front of the
first column, not on any other and not at the back.

The law `transpose_two_by_two` is the whole thing on a matrix a reader can check
by eye: a two-by-two matrix transposes to the matrix with its rows and columns
exchanged. The laws above say how each step works; this one says the steps add
up to the answer.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.transpose_nil()`, `def L.transpose_cons(r, rs)`,
`def L.transpose_single_row(r)`, `def L.insert_row_nil(cols)`,
`def L.insert_row_empty_cols(h, t)`, `def L.insert_row_cons_cols(h, t, c, cs)`
and `def L.transpose_two_by_two()`.
