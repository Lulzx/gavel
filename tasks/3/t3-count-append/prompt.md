Implement `count`, then prove the four laws in `LAWS.bend`.

`count(x, xs)` is the number of elements of `xs` equal to `x`; it is `0n` on
the empty list:

    count(2n, [2n, 1n, 2n]) == 2n
    count(5n, [2n, 1n]) == 0n

The laws use the prelude's `P.append(xs, ys)`, the elements of `xs` followed by
those of `ys`, and `P.is_eq(a, b)`, which is `1n` when `a` equals `b` and `0n`
otherwise (a `Nat`, not a `Bool`).

- `count_nil`: the count in the empty list is `0n`.
- `count_cons`: the count in `h <> t` is `P.is_eq(x, h)` plus the count in `t`.
- `count_self`: the count of `x` in the one-element list `x <> Nil{}` is `1n`.
- `count_append`: the count in `xs` appended to `ys` is the count in `xs` plus
  the count in `ys`.
