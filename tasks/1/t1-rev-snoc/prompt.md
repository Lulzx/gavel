Implement `snoc`, then prove the one law in `LAWS.bend`.

`snoc(xs, x)` is the elements of `xs` followed by `x`: the new element goes on
the right end, the opposite of a cons.

    snoc([1n, 2n], 3n) == [1n, 2n, 3n]
    snoc(Nil{}, 3n)    == [3n]
    snoc([5n], 6n)     == [5n, 6n]

The law uses `P.reverse(xs)`, the elements of `xs` in the opposite order.

- `rev_snoc`: reversing `snoc(xs, x)` gives `x` in front of the reversal of
  `xs`: `P.reverse(snoc(xs, x))` is `x <> P.reverse(xs)`.
