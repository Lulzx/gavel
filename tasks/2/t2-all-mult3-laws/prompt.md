Implement `all_mult3`, then prove the two laws in `LAWS.bend`.

`all_mult3(xs)` is `True{}` when every element of `xs` is a multiple of three
and `False{}` otherwise. The empty list qualifies.

    all_mult3(Nil{}) == True{}
    all_mult3([3n, 9n, 0n]) == True{}
    all_mult3([3n, 4n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_mult3_b(n)` is `True{}` when `n` is a multiple of three and `False{}`
otherwise.

- `all_mult3_nil`: the empty list satisfies `all_mult3`.
- `all_mult3_snoc`: `all_mult3` of a list `xs` with one element `x` added at
  the end is `Bool.and` of `all_mult3(xs)` and `P.is_mult3_b(x)`.
