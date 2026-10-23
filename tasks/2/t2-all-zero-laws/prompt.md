Implement `all_zero`, then prove the two laws in `LAWS.bend`.

`all_zero(xs)` is `True{}` when every element of `xs` is `0n` and `False{}` otherwise. The empty list
qualifies.

    all_zero(Nil{}) == True{}
    all_zero([0n, 0n]) == True{}
    all_zero([0n, 1n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_zero_b(n)` is `True{}` when `n` is `0n` and `False{}` otherwise.

- `all_zero_nil`: the empty list satisfies `all_zero`.
- `all_zero_snoc`: `all_zero` of a list `xs` with one element `x` added at the end is
  `Bool.and` of `all_zero(xs)` and `P.is_zero_b(x)`.
