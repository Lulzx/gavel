Implement `all_one`, then prove the two laws in `LAWS.bend`.

`all_one(xs)` is `True{}` when every element of `xs` is exactly `1n` and `False{}` otherwise. The empty list
qualifies.

    all_one(Nil{}) == True{}
    all_one([1n, 1n]) == True{}
    all_one([1n, 2n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_one_b(n)` is `True{}` when `n` is exactly `1n` and `False{}` otherwise.

- `all_one_nil`: the empty list satisfies `all_one`.
- `all_one_snoc`: `all_one` of a list `xs` with one element `x` added at the end is
  `Bool.and` of `all_one(xs)` and `P.is_one_b(x)`.
