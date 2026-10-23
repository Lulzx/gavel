Implement `max_all`, then prove the two laws in `LAWS.bend`.

`max_all(xs, n)` raises every element of `xs` that is below `n` up to `n`: each
element `h` becomes the larger of `h` and `n`. The list keeps its length and
order. The empty list gives the empty list.

    max_all([1n, 7n, 3n], 4n) == [4n, 7n, 4n]
    max_all([5n], 2n)         == [5n]
    max_all(Nil{}, 4n)        == Nil{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.max(a, b)` is the larger of two numbers.

- `max_all_single`: `max_all(h <> Nil{}, n)` is `P.max(h, n) <> Nil{}`.
- `max_all_append`: `max_all` of `P.append(xs, ys)` with `n` is `P.append` of
  `max_all(xs, n)` and `max_all(ys, n)`.
