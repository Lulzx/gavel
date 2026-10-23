Implement `max_all` and `cum_max`, then prove the seven laws in `LAWS.bend`.

`cum_max(xs)` is the running maximum: at each position, the largest element seen
so far, from the start of the list up to and including that position. It is
exactly as long as `xs`.

`max_all(ys, m)` replaces every element of `ys` by the larger of that element and
`m`, keeping the order, so it is as long as `ys`.

    cum_max([3n, 1n, 2n]) == [3n, 3n, 3n]
    cum_max([1n, 2n, 3n]) == [1n, 2n, 3n]
    cum_max([7n]) == [7n]
    max_all([1n, 5n, 2n], 3n) == [3n, 5n, 3n]

The prelude's `P.len(xs)` is the number of elements of `xs`.

- `max_all_nil`: `max_all(Nil{}, m)` is the empty list.
- `max_all_cons`: `max_all(h <> t, m)` is `Nat.max(h, m)` in front of
  `max_all(t, m)`.
- `cum_max_nil`: `cum_max(Nil{})` is the empty list.
- `cum_max_single`: `cum_max(x <> Nil{})` is `x <> Nil{}`.
- `cum_max_cons`: for a list `h <> t`, the answer is `h` followed by
  `max_all(cum_max(t), h)`: the running maxima of the tail, each raised to at
  least `h`.
- `cum_max_len`: the answer is as long as the input,
  `P.len(cum_max(xs)) == P.len(xs)`.
- `cum_max_three`: `cum_max([3n, 1n, 2n])` is `[3n, 3n, 3n]`.
