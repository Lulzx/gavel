Implement `gap_go` and `max_gap`, then prove the seven laws in `LAWS.bend`.

`max_gap(xs)` is the largest distance between two neighbouring elements of
`xs`, and `0n` when `xs` has fewer than two elements. The distance is absolute,
so it does not matter whether the list goes up or down.

`gap_go(xs, prev, best)` continues that scan: `prev` is the element just before
`xs`, and `best` is the largest distance seen so far. It is the largest of
`best` and the distances between consecutive elements of `prev <> xs`, so it is
`best` when `xs` is empty.

    max_gap([3n, 1n, 5n, 2n]) == 4n
    max_gap([1n, 9n, 2n]) == 8n
    max_gap([7n]) == 0n
    gap_go([4n, 9n], 1n, 2n) == 5n

The laws use `P.absdiff(a, b)`, the distance between two numbers, and
`P.same(n, k)`, the list of `n` copies of `k`.

- `max_gap_nil`: the empty list has largest gap `0n`.
- `max_gap_single`: a one-element list has largest gap `0n`, not the element.
- `max_gap_cons`: `max_gap(h <> t)` is `gap_go(t, h, 0n)`.
- `gap_go_nil`: `gap_go` on the empty list is `best`, whatever `prev` is.
- `gap_go_cons`: `gap_go(h <> t, prev, best)` is `gap_go(t, h, Nat.max(P.absdiff(prev, h), best))`.
- `gap_go_same`: `gap_go` over `P.same(n, k)` with `k` as the previous element
  is `best`, since every distance is `0n`.
- `max_gap_three`: `max_gap([1n, 9n, 2n])` is `8n`.
