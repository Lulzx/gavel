Implement `double_all`, then prove the two laws in `LAWS.bend`.

`double_all(xs)` is the list of the same length in which every element is
replaced by its double, `h + h`. The empty list gives the empty list.

    double_all([1n, 4n]) == [2n, 8n]
    double_all([0n, 3n]) == [0n, 6n]
    double_all(Nil{})    == Nil{}

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `double_all_single`: `double_all(h <> Nil{})` is `(h + h) <> Nil{}`.
- `double_all_append`: `double_all` of `P.append(xs, ys)` is `P.append` of
  `double_all(xs)` and `double_all(ys)`.
