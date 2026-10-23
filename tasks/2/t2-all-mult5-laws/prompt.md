Implement `all_mult5`, then prove the two laws in `LAWS.bend`.

`all_mult5(xs)` is `True{}` when every element of `xs` is a multiple of five and `False{}` otherwise. The empty list
qualifies.

    all_mult5(Nil{}) == True{}
    all_mult5([5n, 0n, 15n]) == True{}
    all_mult5([5n, 6n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_mult5_b(n)` is `True{}` when `n` is a multiple of five and `False{}` otherwise.

- `all_mult5_nil`: the empty list satisfies `all_mult5`.
- `all_mult5_snoc`: `all_mult5` of a list `xs` with one element `x` added at the end is
  `Bool.and` of `all_mult5(xs)` and `P.is_mult5_b(x)`.
