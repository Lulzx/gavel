Implement `has_mult5`, then prove the two laws in `LAWS.bend`.

`has_mult5(xs)` is `True{}` when some element of `xs` is a multiple of five, and `False{}` otherwise. The empty
list has no such element.

    has_mult5([1n, 5n]) == True{}
    has_mult5([1n, 2n]) == False{}
    has_mult5(Nil{}) == False{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.is_mult5_b(n)` is `True{}` when `n` is a multiple of five and `False{}`
otherwise.

- `has_mult5_nil`: `has_mult5(Nil{})` is `False{}`.
- `has_mult5_snoc`: `has_mult5` of `P.append(xs, x <> Nil{})` is
  `Bool.or(has_mult5(xs), P.is_mult5_b(x))`: adding one element at the end ors in
  that element's test.
