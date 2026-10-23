Implement `count_below` and `count_above`, then prove the four laws in `LAWS.bend`.

`count_below(x, xs)` is the number of elements of `xs` that are at most `x`.
`count_above(x, xs)` is the number of elements of `xs` that are strictly above
`x`. Both are `0n` on the empty list.

    count_below(3n, [1n, 3n, 5n, 2n]) == 3n
    count_above(3n, [1n, 3n, 5n, 2n]) == 1n
    count_below(0n, [0n, 1n]) == 1n
    count_above(3n, Nil{}) == 0n

The prelude's `P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}`
otherwise. `P.len(xs)` is the number of elements of `xs`.

- `count_below_nil`: no element of the empty list is at most `x`, so the count
  is `0n`.
- `count_below_keep`: when `P.le(h, x) == True{}`, `count_below(x, h <> t)` is
  `1n + count_below(x, t)`.
- `count_below_drop`: when `P.le(h, x) == False{}`, `count_below(x, h <> t)` is
  `count_below(x, t)`.
- `count_below_split`: the two counts add up to the length of the list,
  `count_below(x, xs) + count_above(x, xs) == P.len(xs)`.
