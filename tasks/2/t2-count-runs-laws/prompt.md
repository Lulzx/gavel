Implement `count_runs`, then prove the four laws in `LAWS.bend`.

`count_runs(xs)` is the number of runs in `xs`: maximal blocks of consecutive
equal elements. The empty list has `0n` runs and a one-element list has `1n`.

    count_runs([1n, 1n, 2n, 2n, 2n, 1n]) == 3n
    count_runs([4n, 4n, 4n]) == 1n
    count_runs([1n, 2n, 1n]) == 3n
    count_runs(Nil{}) == 0n

The prelude's `P.is_eq(a, b)` is `1n` when `a` and `b` are the same number and
`0n` otherwise.

- `count_runs_nil`: the empty list has `0n` runs.
- `count_runs_single`: a one-element list has `1n` run.
- `count_runs_same`: two equal neighbours are one run, so
  `count_runs(a <> (a <> t)) == count_runs(a <> t)`.
- `count_runs_diff`: when `P.is_eq(a, b) == 0n` (the first two elements differ),
  `count_runs(a <> (b <> t))` is `1n + count_runs(b <> t)`.
