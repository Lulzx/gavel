Implement `mod5_all`, then prove the two laws in `LAWS.bend`.

`mod5_all(xs)` is `xs` with every element replaced by its remainder modulo
five, in the same order and with the same length.

    mod5_all([4n, 6n, 12n]) == [4n, 1n, 2n]
    mod5_all([]) == Nil{}
    mod5_all([7n]) == [2n]

The laws use `P.mod5(n)`, the remainder of `n` modulo five, and
`P.append(xs, ys)`, the concatenation of two lists.

- `mod5_all_single`: `mod5_all(h <> Nil{})` is `P.mod5(h) <> Nil{}`.
- `mod5_all_append`: `mod5_all(P.append(xs, ys))` is
  `P.append(mod5_all(xs), mod5_all(ys))`.
