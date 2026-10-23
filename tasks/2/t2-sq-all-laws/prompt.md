Implement `sq_all`, then prove the two laws in `LAWS.bend`.

`sq_all(xs)` is `xs` with every element replaced by its square, in the same order
and with the same length.

    sq_all([0n, 3n, 4n]) == [0n, 9n, 16n]
    sq_all([]) == Nil{}
    sq_all([5n]) == [25n]

The laws use `P.sq(n)`, the square of `n`, and `P.append(xs, ys)`, the
concatenation of two lists.

- `sq_all_single`: `sq_all(h <> Nil{})` is `P.sq(h) <> Nil{}`.
- `sq_all_append`: `sq_all(P.append(xs, ys))` is
  `P.append(sq_all(xs), sq_all(ys))`.
