Implement `count_while`, then prove the three laws in `LAWS.bend`.

`count_while(xs, n)` is the length of the longest prefix of `xs` whose elements
are all at most `n`: it counts elements from the front up to the first one
greater than `n`, and counts nothing after that. The empty list counts `0n`.

    count_while([1n, 2n, 5n, 1n], 3n) == 2n
    count_while([4n, 1n], 3n)         == 0n
    count_while([3n, 3n], 3n)         == 2n
    count_while(Nil{}, 3n)            == 0n

`P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}` otherwise.
`P.count_put(c, k)` is `1n + c` when `k` is `True{}` and `0n` when `k` is
`False{}`.

- `count_while_nil`: the empty list counts `0n`, for any `n`.
- `count_while_keep`: when `P.le(h, n)` is `True{}`, `count_while(h <> t, n)`
  is `1n` plus `count_while(t, n)`.
- `count_while_stop`: when `P.le(y, n)` is `False{}`, `count_while(y <> t, n)`
  is `0n`.
