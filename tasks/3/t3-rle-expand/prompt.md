Implement `expand`, then prove the three laws in `LAWS.bend`.

A run `P.Mk{v, k}` (the prelude's `P.Run`) stands for `k` copies of the value
`v`. `expand(rs)` decodes a list of runs into the flat list they stand for:
each run's copies in order, followed by the decoding of the rest. A run with
count `0n` contributes nothing.

    expand([P.Mk{4n, 2n}, P.Mk{1n, 3n}]) == [4n, 4n, 1n, 1n, 1n]
    expand([P.Mk{9n, 0n}, P.Mk{5n, 1n}]) == [5n]
    expand(Nil{}) == Nil{}

The run list is a `List<&2, P.Run>` and the result a `List<&2, Nat>`.
`P.repeat(v, k)` is the list of `k` copies of `v`, `P.append(xs, ys)` is `xs`
followed by `ys`, `P.len(xs)` is the number of elements of `xs`, and
`P.sum_k(rs)` is the sum of the counts of the runs in `rs`.

- `expand_nil`: the empty run list decodes to the empty list.
- `expand_cons`: decoding `P.Mk{v, k} <> t` gives `k` copies of `v` followed by
  the decoding of `t`.
- `expand_len`: the decoded list has as many elements as the sum of the runs'
  counts.
