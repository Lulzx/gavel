Implement `positions`, then prove the four laws in `LAWS.bend`.

`positions(x, xs)` is the list of the positions at which `x` occurs in `xs`,
counting from `0n`, in increasing order. If `x` does not occur it is `Nil{}`.
The lists are `List<&2, Nat>`.

    positions(5n, [5n, 4n, 5n]) == [0n, 2n]
    positions(9n, [5n, 4n]) == Nil{}
    positions(4n, [5n, 4n, 4n]) == [1n, 2n]

The laws use `P.eq(a, b)`, the `Bool` that says `a` equals `b`;
`P.at_if(b, u, v)`, which is the list `u` when `b` is `True{}` and the list `v`
when it is `False{}`; and `P.inc_all(xs)`, `xs` with every element increased
by `1n`.

- `positions_nil`: on the empty list the answer is `Nil{}`, whatever `x` is.
- `positions_step`: `positions(x, h <> t)` is, through `P.at_if` on the test
  `P.eq(h, x)`, either `0n` followed by `P.inc_all(positions(x, t))` when they
  are equal, or `P.inc_all(positions(x, t))` alone when they are not.
- `positions_hit`: `positions(k, k <> t)` is `0n <> P.inc_all(positions(k, t))`.
- `positions_miss`: `positions(0n, P.inc_all(xs))` is `Nil{}`, since nothing in
  `P.inc_all(xs)` is `0n`.
