Implement `all_even`, then prove the two laws in `LAWS.bend`.

`all_even(xs)` is `True{}` when every element of `xs` is even and `False{}`
otherwise. The empty list is all even.

    all_even(Nil{}) == True{}
    all_even([2n, 4n]) == True{}
    all_even([2n, 3n]) == False{}

The prelude's `P.append(xs, ys)` is the list `xs` followed by the list `ys`,
and `P.is_even_b(n)` is `True{}` when `n` is even and `False{}` otherwise.

- `all_even_nil`: the empty list is all even.
- `all_even_snoc`: `all_even` of a list `xs` with one element `x` added at the
  end is `Bool.and` of `all_even(xs)` and `P.is_even_b(x)`.
