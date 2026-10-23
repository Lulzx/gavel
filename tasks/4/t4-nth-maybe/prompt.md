Implement `nth`, then prove the four laws in `LAWS.bend`.

`nth(k, xs)` is the element of `xs` at index `k`, counting from `0n`, as a
`Maybe<&2, Nat>`: `Some{x}` when `k` is less than the length of `xs` and `x` is
the element at that position, and `None{}` when `xs` has no element at index
`k`. On the empty list every index gives `None{}`.

    nth(0n, [4n, 7n]) == Some{4n}
    nth(1n, [4n, 7n]) == Some{7n}
    nth(2n, [4n, 7n]) == None{}
    nth(0n, Nil{}) == None{}

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`, and
`P.is_some(m)`, which is `True{}` for `Some{x}` and `False{}` for `None{}`.
`Nat.is_lt(a, b)` is Base's comparison, `True{}` when `a` is less than `b`.

- `nth_zero`: index `0n` of `h <> t` is `Some{h}`.
- `nth_succ`: index `1n + k` of `h <> t` is index `k` of `t`.
- `nth_some`: when `k` is less than the length of `xs`, `nth(k, xs)` is a
  `Some`.
- `nth_none`: when `k` is not less than the length of `xs`, `nth(k, xs)` is
  `None{}`.
