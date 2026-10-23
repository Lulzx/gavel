Implement `min_all`, then prove the two laws in `LAWS.bend`.

`min_all(xs, n)` is `xs` with every element capped at `n`: each element `h`
becomes `P.min(h, n)`, in the same order and with the same length.

    min_all([1n, 5n, 3n], 3n) == [1n, 3n, 3n]
    min_all([], 4n) == Nil{}
    min_all([7n], 2n) == [2n]

The laws use `P.min(a, b)`, the smaller of two numbers, and `P.append(xs, ys)`,
the concatenation of two lists.

- `min_all_single`: capping a one-element list `h <> Nil{}` at `n` gives the
  one-element list `P.min(h, n) <> Nil{}`.
- `min_all_append`: capping a concatenation is the concatenation of the capped
  pieces: `min_all(P.append(xs, ys), n)` is
  `P.append(min_all(xs, n), min_all(ys, n))`.
