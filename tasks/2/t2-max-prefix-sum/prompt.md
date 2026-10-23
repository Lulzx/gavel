Implement `max_prefix_sum` and `max_prefix_sum_go`, then prove the five laws in
`LAWS.bend`.

`max_prefix_sum(xs)` is the largest sum over any prefix of `xs`. The empty
prefix counts and sums to `0n`, so the empty list gives `0n`.

`max_prefix_sum_go(xs, acc, best)` continues a scan in progress: `acc` is the
sum of the elements already consumed and `best` is the largest prefix sum seen
so far. It gives the largest of `best` and `acc` plus each prefix sum of `xs`,
so on the empty list it is `best`.

    max_prefix_sum([3n, 1n, 2n]) == 6n
    max_prefix_sum(Nil{}) == 0n
    max_prefix_sum_go([2n, 5n], 1n, 4n) == 8n

The laws use `P.max2(a, b)`, the larger of two numbers.

- `max_prefix_sum_nil`: the empty list gives `0n`.
- `max_prefix_sum_walk`: `max_prefix_sum(xs)` is `max_prefix_sum_go(xs, 0n, 0n)`.
- `mpg_nil`: `max_prefix_sum_go` on the empty list is `best`, whatever `acc` is.
- `mpg_cons`: `max_prefix_sum_go(h <> t, acc, best)` is
  `max_prefix_sum_go(t, Nat.add(acc, h), P.max2(Nat.add(acc, h), best))`.
- `max_prefix_sum_three`: `max_prefix_sum([3n, 1n, 2n])` is `6n`.
