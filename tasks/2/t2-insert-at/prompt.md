Implement `insert_at`, then prove the four laws in `LAWS.bend`.

`insert_at(n, xs, y)` puts `y` into `xs` so that it sits at position `n`,
counting from the front, and leaves the order of the other elements alone.
Position `0n` is in front of the whole list. If `n` is larger than the length
of `xs`, `y` goes on the end.

    insert_at(2n, [1n, 2n, 3n], 9n) == [1n, 2n, 9n, 3n]
    insert_at(0n, [1n], 9n)         == [9n, 1n]
    insert_at(7n, [1n], 9n)         == [1n, 9n]

The laws use these prelude names. `P.append(xs, ys)` is `xs` followed by `ys`.
`P.take(n, xs)` is the first `n` elements of `xs`, or all of `xs` when it is
shorter. `P.drop(n, xs)` is `xs` without its first `n` elements, or the empty
list when it is shorter.

- `insert_at_zero`: `insert_at(0n, xs, y)` is `y <> xs`.
- `insert_at_nil`: `insert_at(1n + n, Nil{}, y)` is `y <> Nil{}`.
- `insert_at_cons`: `insert_at(1n + n, h <> t, y)` is `h` in front of
  `insert_at(n, t, y)`.
- `insert_at_take_drop`: `insert_at(n, xs, y)` is `P.append` of `P.take(n, xs)`
  and `y <> P.drop(n, xs)`: the first `n` elements, then `y`, then the rest.
