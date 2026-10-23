Implement `concat`, then prove the two laws in `LAWS.bend`.

`concat(xss)` flattens a list of lists: it is the inner lists of `xss`, one
after another, in order, as a single list. The empty list of lists flattens to
`Nil{}`.

    concat([[1n, 2n], Nil{}, [3n]]) == [1n, 2n, 3n]
    concat([[5n]]) == [5n]
    concat(Nil{}) == Nil{}

The laws use two prelude functions. `P.append(xs, ys)` is the elements of `xs`
followed by those of `ys`. `P.append_ll(xss, ys)` is the list of lists `xss`
with the single list `ys` added as one more inner list at the end.

- `concat_nil`: `concat(Nil{})` is `Nil{}`.
- `concat_append`: flattening `P.append_ll(xss, ys)` gives the flattening of
  `xss` followed by `ys`.
