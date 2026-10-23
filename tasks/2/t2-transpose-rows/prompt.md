Implement `insert_row` and `transpose`, then prove the seven laws in
`LAWS.bend`.

A matrix is a list of rows, each a list of `Nat`.

`transpose(rows)` swaps rows and columns: its first row is the first column of
`rows`, its second row the second column, and so on. The empty matrix transposes
to the empty matrix. It is built from `insert_row`: transposing a matrix whose
first row is `r` is `r` inserted by `insert_row` into `c`, where `c` is the
transpose of the other rows.

`insert_row(r, cols)` puts the elements of `r` on the fronts of the columns in
`cols`, in order: the first element on the front of the first column, the
second on the front of the second, and so on. If `r` is shorter than `cols`,
the remaining columns are unchanged. If `r` is longer, each extra element
becomes a new one-element column after the existing ones.

    transpose([[1n, 2n], [3n, 4n]]) == [[1n, 3n], [2n, 4n]]
    transpose([[1n, 2n, 3n]]) == [[1n], [2n], [3n]]
    insert_row([1n, 2n], [[3n], [4n]]) == [[1n, 3n], [2n, 4n]]
    insert_row([1n, 2n, 3n], [[9n]]) == [[1n, 9n], [2n], [3n]]

The laws use the prelude's `P.singletons(r)`, the list of one-element lists made
from the elements of `r`, in order (`[[1n], [2n]]` for `[1n, 2n]`).

- `transpose_nil`: the empty matrix transposes to the empty matrix.
- `transpose_cons`: transposing `r <> rs` is `insert_row` of the row `r` into
  the transpose of `rs`.
- `transpose_single_row`: transposing a matrix of the single row `r` gives
  `P.singletons(r)`.
- `insert_row_nil`: inserting the empty row into `cols` gives `cols`.
- `insert_row_empty_cols`: inserting `h <> t` into no columns gives the
  one-element column `h <> Nil{}` followed by the result of inserting `t` into
  no columns.
- `insert_row_cons_cols`: inserting `h <> t` into `c <> cs` gives the column
  `h <> c` followed by the result of inserting `t` into `cs`.
- `transpose_two_by_two`: the transpose of `[[1n, 2n], [3n, 4n]]` is
  `[[1n, 3n], [2n, 4n]]`.
