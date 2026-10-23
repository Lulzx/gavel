Implement `count_matches`, then prove the four laws in `LAWS.bend`.

`count_matches(xs, ys)` counts the positions at which the two lists hold the
same number, comparing them position by position and stopping when either list
runs out. If either list is empty the count is `0n`.

    count_matches([1n, 2n, 3n], [1n, 5n, 3n]) == 2n
    count_matches([1n, 2n], [1n, 2n, 3n, 4n]) == 2n
    count_matches([1n, 2n], Nil{}) == 0n
    count_matches(Nil{}, [1n]) == 0n

The prelude's `P.eq(a, b)` is `True{}` when `a` and `b` are the same number and
`False{}` otherwise. `P.pick(c, a, b)` is `a` when `c` is `True{}` and `b` when
it is `False{}`. `P.len(xs)` is the number of elements of `xs`.

- `count_matches_nil`: with an empty first list the count is `0n`, whatever `ys`
  is.
- `count_matches_nil_right`: with an empty second list the count is `0n`, however
  long the first list is.
- `count_matches_cons`: for `h <> t` and `k <> u`, the count is `1n` or `0n`
  according to whether `h` and `k` are the same (`P.pick(P.eq(h, k), 1n, 0n)`),
  added to `count_matches(t, u)`.
- `count_matches_self`: a list matches itself everywhere, so
  `count_matches(xs, xs) == P.len(xs)`.
