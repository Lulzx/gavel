Implement `split_at`, then prove the five laws in `LAWS.bend`.

`split_at(n, xs)` splits `xs` after its first `n` elements, answered as
`P.MkDuo{left, right}`: `left` is the first `n` elements and `right` is the rest.
When `xs` has fewer than `n` elements, `left` is all of `xs` and `right` is
`Nil{}`. The lists are `List<&2, Nat>`.

    split_at(2n, [1n, 2n, 3n, 4n]) == P.MkDuo{1n <> 2n <> Nil{}, 3n <> 4n <> Nil{}}
    split_at(5n, [1n, 2n]) == P.MkDuo{1n <> 2n <> Nil{}, Nil{}}
    split_at(0n, [1n, 2n]) == P.MkDuo{Nil{}, 1n <> 2n <> Nil{}}

The laws use the projections `P.left_half(p)` and `P.right_half(p)` of a
`P.Duo`, and `P.append(xs, ys)`, the concatenation of two lists.

- `split_at_zero`: `split_at(0n, xs)` is `P.MkDuo{Nil{}, xs}`.
- `split_at_nil`: `split_at(n, Nil{})` is `P.MkDuo{Nil{}, Nil{}}`, whatever `n` is.
- `split_at_cons_left`: the left half of `split_at(1n + n, x <> xs)` is `x` in
  front of the left half of `split_at(n, xs)`.
- `split_at_cons_right`: the right half of `split_at(1n + n, x <> xs)` is the
  right half of `split_at(n, xs)`.
- `split_at_decomp`: appending the two halves of `split_at(n, xs)` gives `xs`.
