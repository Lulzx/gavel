Implement `take_last`, then prove the seven laws in `LAWS.bend`.

`take_last(xs, k)` is the last `k` elements of `xs`, in their original order.
When `xs` has `k` elements or fewer it is all of `xs`. Taking the last `0n`
elements gives the empty list, and the empty list gives the empty list.

    take_last([1n, 2n, 3n, 4n], 2n) == [3n, 4n]
    take_last([1n, 2n, 3n, 4n], 4n) == [1n, 2n, 3n, 4n]
    take_last([1n, 2n], 5n) == [1n, 2n]
    take_last([1n, 2n], 0n) == Nil{}

The laws use three prelude names. `P.len(xs)` is the number of elements of
`xs`. `P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}` otherwise.
`P.keep_if(b, xs, r)` is `xs` when `b` is `True{}` and `r` when it is `False{}`.

- `take_last_nil`: the empty list gives the empty list, for any `k`.
- `take_last_step`: `take_last(h <> t, k)` is `P.keep_if(d, h <> t, r)`, where
  `d` is `P.le(P.len(h <> t), k)` and `r` is `take_last(t, k)`: the whole list
  when its length is at most `k`, and otherwise the answer for `t`.
- `take_last_single`: a one-element list with a count of `1n + k` gives that
  one-element list.
- `take_last_zero`: taking the last `0n` elements of any list gives the empty
  list.
- `take_last_long`: when `P.le(P.len(xs), k)` is `True{}`, `take_last(xs, k)` is
  `xs`.
- `take_last_three`: the last `2n` elements of `[1n, 2n, 3n]` are `[2n, 3n]`.
- `take_last_all`: the last `5n` elements of `[1n, 2n]` are `[1n, 2n]`.
