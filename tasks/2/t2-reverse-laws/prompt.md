Implement `reverse`, then prove the two laws in `LAWS.bend`.

`reverse(xs)` is the elements of `xs` in the opposite order.

    reverse([1n, 2n, 3n]) == [3n, 2n, 1n]
    reverse([5n]) == [5n]
    reverse(Nil{}) == Nil{}

The laws use `P.snoc(xs, x)`, `xs` with `x` added at the end.

- `reverse_single`: `reverse(h <> Nil{})` is `h <> Nil{}`.
- `reverse_snoc`: `reverse(P.snoc(xs, x))` is `x <> reverse(xs)`: the last
  element comes first.
