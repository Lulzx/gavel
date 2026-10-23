Implement `diffs`, then prove the four laws in `LAWS.bend`.

`diffs(xs)` is the successive differences of `xs`: the second element minus the
first, the third minus the second, and so on, so it has one element fewer than
`xs`. Subtraction is truncated at zero, so a difference is never negative. The
empty list and a one-element list have no pairs, so both give `Nil{}`.

    diffs([3n, 1n, 4n, 1n]) == [0n, 3n, 0n]
    diffs([1n, 4n, 6n])     == [3n, 2n]
    diffs([5n])             == Nil{}

The laws use `P.sub(a, b)`, truncated subtraction (`a - b` when `a` is at least
`b`, otherwise `0n`), and `P.len(xs)`, the number of elements of `xs`.

- `diffs_nil`: `diffs(Nil{})` is `Nil{}`.
- `diffs_single`: `diffs(x <> Nil{})` is `Nil{}`.
- `diffs_cons`: `diffs(a <> (b <> t))` is `P.sub(b, a)` in front of
  `diffs(b <> t)`.
- `diffs_len`: `diffs(x <> xs)` has as many elements as `xs`.
