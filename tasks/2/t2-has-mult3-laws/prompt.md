Implement `has_mult3`, then prove the two laws in `LAWS.bend`.

`has_mult3(xs)` is `True{}` when some element of `xs` is a multiple of three, and `False{}` otherwise. The empty
list has no such element.

    has_mult3([1n, 3n]) == True{}
    has_mult3([1n, 2n]) == False{}
    has_mult3(Nil{}) == False{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.is_mult3_b(n)` is `True{}` when `n` is a multiple of three and `False{}`
otherwise.

- `has_mult3_nil`: `has_mult3(Nil{})` is `False{}`.
- `has_mult3_snoc`: `has_mult3` of `P.append(xs, x <> Nil{})` is
  `Bool.or(has_mult3(xs), P.is_mult3_b(x))`: adding one element at the end ors in
  that element's test.
