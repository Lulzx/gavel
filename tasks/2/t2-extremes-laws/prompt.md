Implement `extremes` and `ext_go`, then prove the six laws in `LAWS.bend`.

`extremes(xs)` is a two-element list holding the smallest element of `xs`
followed by the largest. The empty list has no extremes, so it gives the empty
list. A one-element list gives that element twice.

    extremes([3n, 1n, 2n]) == [1n, 3n]
    extremes([4n])         == [4n, 4n]
    extremes(Nil{})        == Nil{}

`ext_go(xs, lo, hi)` is the same computation starting from a running minimum
`lo` and a running maximum `hi`: the answer is `[lo', hi']`, where `lo'` is the
smaller of `lo` and every element of `xs`, and `hi'` is the larger of `hi` and
every element of `xs`. With `xs` empty it is `[lo, hi]`.

    ext_go([2n, 7n], 4n, 5n) == [2n, 7n]
    ext_go(Nil{}, 4n, 5n)    == [4n, 5n]

The laws use these prelude names. `P.min2(a, b)` is the smaller of two numbers
and `P.max2(a, b)` the larger. `P.len(xs)` is the number of elements of `xs`.

- `extremes_nil`: `extremes(Nil{})` is the empty list.
- `extremes_single`: `extremes(x <> Nil{})` is `x <> x <> Nil{}`.
- `extremes_cons`: `extremes(x <> xs)` is `ext_go(xs, x, x)`.
- `ext_go_nil`: `ext_go(Nil{}, lo, hi)` is `lo <> hi <> Nil{}`.
- `ext_go_cons`: `ext_go(h <> t, lo, hi)` is `ext_go(t, P.min2(h, lo), P.max2(h, hi))`.
- `ext_go_len`: `ext_go(xs, lo, hi)` has exactly two elements, for every `xs`,
  `lo` and `hi`.
