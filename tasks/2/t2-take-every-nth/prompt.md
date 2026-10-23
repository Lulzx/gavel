Implement `take_every_nth` and `every_nth_go`, then prove the nine laws in
`LAWS.bend`.

`take_every_nth(n, xs)` keeps the elements of `xs` at positions `0n`, `n`, `2n`,
and so on (counting from `0n`), in order, and drops the rest. A stride of `0n`
names no position, so it gives the empty list.

`every_nth_go(xs, m, i)` is the walk behind it: `m` is the number of elements
dropped between two kept ones (the stride minus one) and `i` is the number
still to drop before the next kept element. It drops the first `i` elements of
`xs`, keeps the next, then drops `m`, keeps one, and so on. `take_every_nth`
with a stride of `1n + n` is `every_nth_go(xs, n, 0n)`.

    take_every_nth(2n, [1n, 2n, 3n, 4n, 5n]) == [1n, 3n, 5n]
    take_every_nth(3n, [1n, 2n, 3n, 4n, 5n, 6n, 7n]) == [1n, 4n, 7n]
    take_every_nth(0n, [1n, 2n, 3n]) == Nil{}
    every_nth_go([1n, 2n, 3n, 4n, 5n], 1n, 1n) == [2n, 4n]

- `take_every_nth_zero`: a stride of `0n` gives the empty list, for any list.
- `take_every_nth_nil`: the empty list gives the empty list, for any stride.
- `take_every_nth_one`: a stride of `1n` keeps every element, so it gives `xs`.
- `take_every_nth_step`: `take_every_nth(1n + n, xs)` is
  `every_nth_go(xs, n, 0n)`.
- `every_nth_go_nil`: the walk on the empty list gives the empty list, for any
  `m` and `i`.
- `every_nth_go_take`: with nothing left to drop, the walk on `h <> t` keeps
  `h` and puts the walk on `t`, with `m` to drop, after it.
- `every_nth_go_skip`: with `1n + k` left to drop, the walk on `h <> t` drops
  `h`, and the answer is the walk on `t` with `k` left to drop.
- `take_every_nth_five`: stride `2n` on `[1n, 2n, 3n, 4n, 5n]` gives
  `[1n, 3n, 5n]`.
- `take_every_nth_seven`: stride `3n` on `[1n, 2n, 3n, 4n, 5n, 6n, 7n]` gives
  `[1n, 4n, 7n]`.
