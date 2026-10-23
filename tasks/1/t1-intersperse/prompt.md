Implement `intersperse`, then prove the four laws in `LAWS.bend`.

`intersperse(xs, sep)` puts `sep` between every two neighbours of `xs` and
nowhere else: one `sep` per gap, none before the first element and none after
the last. The empty list and a one-element list come back unchanged.

    intersperse([1n, 2n, 3n], 0n) == [1n, 0n, 2n, 0n, 3n]
    intersperse([4n, 5n], 9n)     == [4n, 9n, 5n]
    intersperse([7n], 0n)         == [7n]
    intersperse(Nil{}, 0n)        == Nil{}

The laws use `P.len(xs)`, the number of elements of `xs`, and `P.ilen(xs)`, the
length the answer should have: `0n` for the empty list, and otherwise one for
the first element plus two for each element after it.

- `intersperse_nil`: `intersperse(Nil{}, sep)` is `Nil{}`.
- `intersperse_single`: `intersperse(x <> Nil{}, sep)` is `x <> Nil{}`.
- `intersperse_cons`: `intersperse(a <> (b <> t), sep)` is `a`, then `sep`, then
  `intersperse(b <> t, sep)`.
- `intersperse_len`: `P.len(intersperse(xs, sep))` equals `P.ilen(xs)`.
