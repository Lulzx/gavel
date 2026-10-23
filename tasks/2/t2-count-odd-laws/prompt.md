Implement `count_odd`, then prove the two laws in `LAWS.bend`.

`count_odd(xs)` is the number of odd elements of `xs`. The empty list has none.

    count_odd([1n, 2n, 3n]) == 2n
    count_odd([2n, 4n]) == 0n
    count_odd(Nil{}) == 0n

The prelude's `P.append(xs, ys)` is `xs` followed by `ys`. `P.is_odd(n)` is `1n`
when `n` is odd and `0n` when it is even.

- `count_odd_nil`: the empty list has `0n` odd elements.
- `count_odd_snoc`: adding one element `x` at the end of `xs` adds whether it is
  odd: `count_odd(P.append(xs, x <> Nil{})) == count_odd(xs) + P.is_odd(x)`.
