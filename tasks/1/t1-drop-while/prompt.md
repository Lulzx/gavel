Implement `drop_while`, then prove the three laws in `LAWS.bend`.

`drop_while(xs, n)` removes the longest prefix of `xs` whose elements are all at
most `n`. It returns what is left: the first element greater than `n` and
everything after it, unchanged. If no element is greater than `n`, the answer is
`Nil{}`.

    drop_while([1n, 2n, 5n, 1n], 3n) == [5n, 1n]
    drop_while([4n, 1n], 3n)         == [4n, 1n]
    drop_while([1n, 2n], 3n)         == Nil{}
    drop_while(Nil{}, 3n)            == Nil{}

`P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}` otherwise.
`P.drop_put(h, t, r, k)` is `r` when `k` is `True{}` and `h <> t` when `k` is
`False{}`.

- `drop_while_nil`: `drop_while(Nil{}, n)` is `Nil{}`, for any `n`.
- `drop_while_keep`: when `P.le(h, n)` is `True{}`, `drop_while(h <> t, n)` is
  `drop_while(t, n)`.
- `drop_while_stop`: when `P.le(y, n)` is `False{}`, `drop_while(y <> t, n)` is
  `y <> t`.
