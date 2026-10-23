Implement `take_while`, then prove the three laws in `LAWS.bend`.

`take_while(xs, n)` is the longest prefix of `xs` whose elements are all at
most `n`, in order: it keeps elements from the front up to the first one
greater than `n`, and drops that one and everything after it. If no element is
greater than `n`, the answer is all of `xs`.

    take_while([1n, 2n, 5n, 1n], 3n) == [1n, 2n]
    take_while([4n, 1n], 3n)         == Nil{}
    take_while([1n, 2n], 3n)         == [1n, 2n]
    take_while(Nil{}, 3n)            == Nil{}

`P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}` otherwise.
`P.keep_put(h, r, k)` is `h <> r` when `k` is `True{}` and `Nil{}` when `k` is
`False{}`.

- `take_while_nil`: `take_while(Nil{}, n)` is `Nil{}`, for any `n`.
- `take_while_keep`: when `P.le(h, n)` is `True{}`, `take_while(h <> t, n)` is
  `h` placed in front of `take_while(t, n)`.
- `take_while_stop`: when `P.le(y, n)` is `False{}`, `take_while(y <> t, n)` is
  `Nil{}`.
