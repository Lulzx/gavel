Implement `reverse`, then prove the two laws in `LAWS.bend`.

`reverse(xs)` is the elements of `xs` in the opposite order. The empty list
reverses to itself.

    reverse([1n, 2n, 3n]) == [3n, 2n, 1n]
    reverse([7n])         == [7n]
    reverse(Nil{})        == Nil{}

The laws use `P.append(xs, ys)`, the elements of `xs` followed by those of
`ys`.

- `rev_nil`: `reverse(Nil{})` is `Nil{}`.
- `rev_append`: reversing a list with `x` added at its right end gives `x` in
  front of the reversal of the list: `reverse(P.append(xs, x <> Nil{}))` is
  `x <> reverse(xs)`.
