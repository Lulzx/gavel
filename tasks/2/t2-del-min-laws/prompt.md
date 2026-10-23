Implement `del_min`, then prove the five laws in `LAWS.bend`.

`del_min(xs)` removes one occurrence of the smallest element of `xs`, the first
one if there are several, and keeps every other element in its order. The empty
list stays empty.

    del_min([3n, 1n, 2n, 1n]) == [3n, 2n, 1n]
    del_min([1n, 2n]) == [2n]
    del_min([4n]) == Nil{}
    del_min(Nil{}) == Nil{}

The prelude's `P.le(a, b)` is `True{}` when `a` is at most `b` and `False{}`
otherwise. `P.min_go(t, m)` is the smallest of `m` and all the elements of `t`.
`P.len(xs)` is the number of elements of `xs`.

- `del_min_nil`: the empty list stays empty.
- `del_min_single`: a one-element list becomes empty.
- `del_min_keep`: for a list `x <> y <> t`, when `P.le(x, P.min_go(y <> t, y))`
  is `True{}` (the head `x` is at most everything after it), the answer is the
  tail `y <> t`.
- `del_min_drop`: for a list `x <> y <> t`, when `P.le(x, P.min_go(y <> t, y))`
  is `False{}` (something after `x` is smaller), the answer is `x` in front of
  `del_min(y <> t)`.
- `del_min_len`: removing the smallest element removes exactly one element,
  `P.len(del_min(h <> t)) == P.len(t)`.
