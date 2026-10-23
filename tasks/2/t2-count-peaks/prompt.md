Implement `count_peaks` and `peaks_go`, then prove the six laws in `LAWS.bend`.

`count_peaks(xs)` is the number of elements of `xs` that are strictly greater
than both of their neighbours. An element with only one neighbour is never a
peak, so the first and last elements are not counted and a list of fewer than
three elements has `0n` peaks.

`peaks_go(t, prev, h)` is the walk over the rest of a list. `h` is the element
whose peak status is being decided, `prev` is the element just before `h`, and
`t` is what follows `h`. When `t` is empty, `h` is the last element and the
answer is `0n`. Otherwise the first element `j` of `t` is the neighbour after
`h`: `h` contributes `P.peak_at(prev, h, j)`, added to the walk on the rest of
`t` with `h` as the new `prev` and `j` as the new `h`.

    count_peaks([1n, 3n, 2n, 5n, 4n]) == 2n
    count_peaks([2n, 2n, 2n]) == 0n
    count_peaks([1n, 9n]) == 0n
    peaks_go([5n, 2n], 3n, 1n) == 1n

The prelude's `P.peak_at(prev, h, next)` is `1n` when `h` is strictly greater
than both `prev` and `next`, and `0n` otherwise.

- `count_peaks_nil`: the empty list has `0n` peaks.
- `count_peaks_single`: a one-element list has `0n` peaks.
- `count_peaks_step`: for a list `h <> (j <> u)` of two or more elements,
  `count_peaks` is `peaks_go(u, h, j)`.
- `peaks_go_nil`: `peaks_go(Nil{}, prev, h)` is `0n`.
- `peaks_go_cons`: `peaks_go(j <> u, prev, h)` is `P.peak_at(prev, h, j)` added to
  `peaks_go(u, h, j)`.
- `count_peaks_three`: for a three-element list `[x, y, z]`, `count_peaks` is
  `P.peak_at(x, y, z)`.
