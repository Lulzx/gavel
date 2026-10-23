Implement `count_zeros`, then prove the two laws in `LAWS.bend`.

`count_zeros(xs)` is the number of elements of `xs` equal to `0n`. The empty
list has none.

    count_zeros([0n, 3n, 0n, 0n]) == 3n
    count_zeros([1n, 2n])         == 0n
    count_zeros(Nil{})            == 0n

The laws use `P.append(xs, ys)`, the elements of `xs` followed by those of
`ys`, and `P.is_zero(n)`, which is `1n` when `n` is `0n` and `0n` otherwise.

- `count_zeros_snoc`: adding one element `x` to the right end of `xs` raises the
  count by `P.is_zero(x)`: `count_zeros(P.append(xs, x <> Nil{}))` is
  `count_zeros(xs) + P.is_zero(x)`.
- `count_zeros_nil`: `count_zeros(Nil{})` is `0n`.
