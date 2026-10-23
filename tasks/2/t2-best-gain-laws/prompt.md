Implement `best_gain`, then prove the four laws in `LAWS.bend`.

`best_gain(xs)` is the largest rise between two positions of `xs`, an earlier
one and a later one: the maximum of `later - earlier` over every pair, where
subtraction is truncated, so a fall counts as `0n`. A list with fewer than two
elements has no pair and gives `0n`.

    best_gain([3n, 1n, 4n, 2n, 9n]) == 8n
    best_gain([5n, 3n, 1n]) == 0n
    best_gain([2n, 6n]) == 4n
    best_gain(Nil{}) == 0n

The prelude's `P.max_sub(h, ys)` is the largest rise from `h` to an element of
`ys`: the maximum of `y - h` over the elements `y` of `ys` with truncated
subtraction, and `0n` when `ys` is empty.

- `best_gain_nil`: the empty list gives `0n`.
- `best_gain_single`: a one-element list gives `0n`.
- `best_gain_cons`: for a list `h <> t`, the answer is `Nat.max` of
  `P.max_sub(h, t)` and `best_gain(t)`: the better of the best rise from the
  head and the best gain inside the tail.
- `best_gain_pair`: for a two-element list `[a, b]` the answer is
  `Nat.sub(b, a)`.
