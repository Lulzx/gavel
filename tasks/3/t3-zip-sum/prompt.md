Implement `zip_sum`, then prove the five laws in `LAWS.bend`.

`zip_sum(xs, ys)` adds the two lists element by element, position by position,
and stops when the shorter one runs out.

    zip_sum([1n, 2n, 3n], [10n, 20n]) == [11n, 22n]
    zip_sum(Nil{}, [4n]) == Nil{}

`P.len(xs)` is the number of elements of `xs`, `P.min(a, b)` is the smaller of
`a` and `b`, and `P.double_all(xs)` is `xs` with every element doubled.

- `zip_sum_nil_left`: an empty first list gives `Nil{}`.
- `zip_sum_nil_right`: an empty second list gives `Nil{}`.
- `zip_sum_len`: the result has as many elements as the shorter of the two lists.
- `zip_sum_self`: adding a list to itself doubles every element.
- `zip_sum_cons`: for `h1 <> t1` and `h2 <> t2` the result is `h1 + h2`
  followed by `zip_sum(t1, t2)`.
