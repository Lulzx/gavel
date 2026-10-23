Implement `pred_all`, then prove the two laws in `LAWS.bend`.

`pred_all(xs)` is `xs` with every element replaced by its predecessor, in the
same order and with the same length. The predecessor of `0n` is `0n`.

    pred_all([0n, 3n, 1n]) == [0n, 2n, 0n]
    pred_all([]) == Nil{}
    pred_all([5n]) == [4n]

The laws use `P.pred(n)`, the predecessor of `n` (`0n` for `0n`), and
`P.append(xs, ys)`, the concatenation of two lists.

- `pred_all_single`: `pred_all(h <> Nil{})` is `P.pred(h) <> Nil{}`.
- `pred_all_append`: `pred_all(P.append(xs, ys))` is
  `P.append(pred_all(xs), pred_all(ys))`.
