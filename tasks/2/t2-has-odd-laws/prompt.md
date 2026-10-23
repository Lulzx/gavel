Implement `has_odd`, then prove the two laws in `LAWS.bend`.

`has_odd(xs)` is `True{}` when some element of `xs` is odd, and `False{}` otherwise. The empty
list has no such element.

    has_odd([2n, 3n]) == True{}
    has_odd([2n, 4n]) == False{}
    has_odd(Nil{}) == False{}

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.is_odd_b(n)` is `True{}` when `n` is odd and `False{}`
otherwise.

- `has_odd_nil`: `has_odd(Nil{})` is `False{}`.
- `has_odd_snoc`: `has_odd` of `P.append(xs, x <> Nil{})` is
  `Bool.or(has_odd(xs), P.is_odd_b(x))`: adding one element at the end ors in
  that element's test.
