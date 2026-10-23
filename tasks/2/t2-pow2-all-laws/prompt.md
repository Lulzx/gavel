Implement `pow2_all`, then prove the two laws in `LAWS.bend`.

`pow2_all(xs)` is `xs` with every element `n` replaced by two to the power `n`,
in the same order and with the same length.

    pow2_all([0n, 3n, 1n]) == [1n, 8n, 2n]
    pow2_all([]) == Nil{}
    pow2_all([4n]) == [16n]

The laws use `P.pow2(n)`, two to the power `n`, and `P.append(xs, ys)`, the
concatenation of two lists.

- `pow2_all_single`: `pow2_all(h <> Nil{})` is `P.pow2(h) <> Nil{}`.
- `pow2_all_append`: `pow2_all(P.append(xs, ys))` is
  `P.append(pow2_all(xs), pow2_all(ys))`.
