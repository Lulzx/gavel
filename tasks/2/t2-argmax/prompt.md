Implement `argmax` and `argmax_go`, then prove the seven laws in `LAWS.bend`.

`argmax(xs)` is the position of the largest element of `xs`, counting from
`0n`. When the largest element occurs more than once, it is the position of the
first occurrence. The empty list answers `0n`.

`argmax_go(xs, cur, bi, i)` walks `xs` carrying three running values: `cur`, the
largest element seen so far; `bi`, the position in the whole list of that
element; and `i`, the position in the whole list of the first element of `xs`.
It answers the position of the largest element once `xs` is exhausted. When the
head of `xs` is strictly greater than `cur` it becomes the new largest, at
position `i`. A head that only ties with `cur` does not move the position.

    argmax([1n, 3n, 2n]) == 1n
    argmax([2n, 3n, 3n, 1n]) == 1n
    argmax([7n]) == 0n
    argmax_go([5n, 2n], 3n, 0n, 1n) == 1n

The prelude's `P.gt(a, b)` is `True{}` when `a` is strictly greater than `b`.
`P.max2(a, b)` is the larger of `a` and `b`. `P.pick_if(b, x, y)` is `x` when
`b` is `True{}` and `y` when it is `False{}`. `P.same(n, k)` is the list of `n`
copies of `k`.

- `argmax_nil`: the empty list answers `0n`.
- `argmax_cons`: for a list `h <> t`, `argmax(h <> t)` is
  `argmax_go(t, h, 0n, 1n)`.
- `argmax_go_nil`: on the empty list `argmax_go(Nil{}, cur, bi, i)` is `bi`.
- `argmax_go_step`: `argmax_go(h <> t, cur, bi, i)` is
  `argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i)`.
- `argmax_three`: `argmax([1n, 3n, 2n])` is `1n`.
- `argmax_tie`: `argmax([2n, 3n, 3n, 1n])` is `1n`.
- `argmax_same`: walking `P.same(n, k)` with `k` as the largest seen so far
  answers `bi`, whatever `bi` and `i` are: `argmax_go(P.same(n, k), k, bi, i) == bi`.
