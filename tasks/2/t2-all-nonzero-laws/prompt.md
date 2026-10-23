Implement `all_nonzero`, then prove the two laws in `LAWS.bend`.

`all_nonzero(xs)` is `True{}` when every element of `xs` is nonzero and `False{}` otherwise. The empty list
qualifies.

    all_nonzero(Nil{}) == True{}
    all_nonzero([1n, 7n]) == True{}
    all_nonzero([1n, 0n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_nonzero_b(n)` is `True{}` when `n` is nonzero and `False{}` otherwise.

- `all_nonzero_nil`: the empty list satisfies `all_nonzero`.
- `all_nonzero_snoc`: `all_nonzero` of a list `xs` with one element `x` added at the end is
  `Bool.and` of `all_nonzero(xs)` and `P.is_nonzero_b(x)`.
