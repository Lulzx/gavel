Implement `has_one`, then prove the two laws in `LAWS.bend`.

`has_one(xs)` is `True{}` when some element of `xs` is `1n`, and `False{}` otherwise. The empty
list has no such element.

    has_one([2n, 1n]) == True{}
    has_one([2n, 3n]) == False{}
    has_one(Nil{}) == False{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.is_one_b(n)` is `True{}` when `n` is `1n` and `False{}`
otherwise.

- `has_one_nil`: `has_one(Nil{})` is `False{}`.
- `has_one_snoc`: `has_one` of `P.append(xs, x <> Nil{})` is
  `Bool.or(has_one(xs), P.is_one_b(x))`: adding one element at the end ors in
  that element's test.
