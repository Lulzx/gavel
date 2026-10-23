Implement `concat_map`, then prove the four laws in `LAWS.bend`.

`concat_map(xs)` replaces every element `x` of `xs` by the two-element list
`[x, x + 1n]` and joins all of these lists together, in order. So the answer has
twice as many elements as `xs`.

    concat_map([1n, 5n]) == [1n, 2n, 5n, 6n]
    concat_map([0n]) == [0n, 1n]
    concat_map(Nil{}) == Nil{}

The prelude's `P.expand(x)` is that two-element list `[x, x + 1n]`.
`P.append(xs, ys)` is `xs` followed by `ys`. `P.concat(xss)` joins a list of
lists into one. `P.map_expand(xs)` is the list of lists with `P.expand` applied
to every element of `xs`. `P.len(xs)` is the number of elements, and
`P.elen(xs)` is twice the number of elements of `xs`.

- `concat_map_nil`: the empty list gives the empty list.
- `concat_map_cons`: for a list `h <> t`, the answer is `P.expand(h)` followed by
  `concat_map(t)`.
- `concat_map_concat`: `concat_map(xs)` equals
  `P.concat(P.map_expand(xs))`.
- `concat_map_len`: the length of `concat_map(xs)` is `P.elen(xs)`.
