Implement `elem_zero`, then prove the two laws in `LAWS.bend`.

`elem_zero(xs)` is `True{}` when `xs` contains a `0n` and `False{}` otherwise.
The empty list contains none.

    elem_zero([3n, 0n]) == True{}
    elem_zero([3n, 1n]) == False{}
    elem_zero(Nil{})    == False{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.is_zero_b(n)` is `True{}` when `n` is `0n` and `False{}`
otherwise.

- `elem_zero_nil`: `elem_zero(Nil{})` is `False{}`.
- `elem_zero_snoc`: `elem_zero` of `P.append(xs, x <> Nil{})` is
  `Bool.or(elem_zero(xs), P.is_zero_b(x))`: adding one element at the end ors
  in that element's zero test.
