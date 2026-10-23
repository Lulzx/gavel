Implement `dec2_all`, then prove the two laws in `LAWS.bend`.

`dec2_all(xs)` replaces every element of `xs` by that element minus two, stopping
at `0n` (so `1n` and `0n` both become `0n`), keeping the order. The empty list
stays empty.

    dec2_all([5n, 1n, 2n]) == [3n, 0n, 0n]
    dec2_all([2n]) == [0n]
    dec2_all(Nil{}) == Nil{}

The prelude's `P.dec2(n)` is `n` minus two, stopping at `0n`. `P.append(xs, ys)`
is `xs` followed by `ys`.

- `dec2_all_single`: a one-element list `h <> Nil{}` becomes `P.dec2(h) <> Nil{}`.
- `dec2_all_append`: the result for an append is the append of the results,
  `dec2_all(P.append(xs, ys)) == P.append(dec2_all(xs), dec2_all(ys))`.
