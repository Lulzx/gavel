Implement `snoc_each` and `front_each`, then prove the five laws in `LAWS.bend`.

Both take a list of rows (`List<&2, List<&2, Nat>>`) and a number `y`.
`snoc_each(xss, y)` puts `y` at the end of every row, and `front_each(xss, y)`
puts `y` at the front of every row. Rows keep their order, and a row that is
empty becomes `[y]`.

    snoc_each([[1n, 2n], Nil{}, [3n]], 9n) == [[1n, 2n, 9n], [9n], [3n, 9n]]
    front_each([[1n, 2n], Nil{}, [3n]], 9n) == [[9n, 1n, 2n], [9n], [9n, 3n]]
    snoc_each(Nil{}, 4n) == Nil{}

The laws use `P.snoc(xs, y)`, the row `xs` with `y` added at the end.

- `snoc_each_nil`: with no rows, `snoc_each(Nil{}, y)` is `Nil{}`.
- `snoc_each_cons`: `snoc_each(l <> t, y)` is `P.snoc(l, y)` followed by
  `snoc_each(t, y)`: the first row with `y` at the end, then the rest.
- `front_each_nil`: with no rows, `front_each(Nil{}, y)` is `Nil{}`.
- `front_each_cons`: `front_each(l <> t, y)` is `(y <> l)` followed by
  `front_each(t, y)`: the first row with `y` in front, then the rest.
- `snoc_front_commute`: doing both gives the same rows in either order:
  `snoc_each(front_each(xss, y), z)` is `front_each(snoc_each(xss, z), y)`.
