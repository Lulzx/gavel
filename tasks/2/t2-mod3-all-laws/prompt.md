Implement `mod3_all`, then prove the two laws in `LAWS.bend`.

`mod3_all(xs)` is `xs` with every element replaced by its remainder modulo
three, in the same order and with the same length.

    mod3_all([4n, 6n, 8n]) == [1n, 0n, 2n]
    mod3_all([]) == Nil{}
    mod3_all([2n]) == [2n]

The laws use `P.mod3(n)`, the remainder of `n` modulo three, and
`P.append(xs, ys)`, the concatenation of two lists.

- `mod3_all_single`: `mod3_all(h <> Nil{})` is `P.mod3(h) <> Nil{}`.
- `mod3_all_append`: `mod3_all(P.append(xs, ys))` is
  `P.append(mod3_all(xs), mod3_all(ys))`.
