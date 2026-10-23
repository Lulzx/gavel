Implement `row` and `cross`, then prove the six laws in `LAWS.bend`.

`row(x, ys)` pairs `x` with every element of `ys`, in the order `ys` has them,
as `P.MkPair{x, y}` records. It is empty when `ys` is empty.

`cross(xs, ys)` pairs every element of `xs` with every element of `ys`: the rows
come in the order of `xs`, and inside a row the pairs come in the order of `ys`.
It is empty when `xs` is empty.

    row(1n, [3n, 4n]) == P.MkPair{1n, 3n} <> P.MkPair{1n, 4n} <> Nil{}
    cross([1n, 2n], [3n]) == P.MkPair{1n, 3n} <> P.MkPair{2n, 3n} <> Nil{}
    cross([1n], Nil{}) == Nil{}
    row(7n, Nil{}) == Nil{}

The prelude's `P.append(ps, qs)` is the list of pairs `ps` followed by `qs`.

- `cross_nil`: `cross(Nil{}, ys)` is empty, whatever `ys` is.
- `row_nil`: `row(x, Nil{})` is empty, whatever `x` is.
- `row_cons`: for `y <> t`, the row is `P.MkPair{x, y}` in front of `row(x, t)`.
- `cross_cons`: for `x <> t`, the product is the row `row(x, ys)` followed by
  `cross(t, ys)`, in the sense of `P.append`.
- `cross_one`: for a one-element first list, `cross(x <> Nil{}, ys)` is just
  `row(x, ys)`.
- `cross_two_two`: `cross([1n, 2n], [3n, 4n])` is
  `[P.MkPair{1n, 3n}, P.MkPair{1n, 4n}, P.MkPair{2n, 3n}, P.MkPair{2n, 4n}]`.
