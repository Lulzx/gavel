Implement `distinct` and `distinct_go`, then prove the seven laws in `LAWS.bend`.

`distinct(xs)` is `xs` with every duplicate removed. The first occurrence of
each element stays, later ones go, and the survivors keep their order. A
duplicate is any element that appeared earlier anywhere in the list, not only
immediately before.

    distinct([1n, 2n, 1n]) == [1n, 2n]
    distinct([3n, 3n, 3n]) == [3n]
    distinct([1n, 2n, 3n]) == [1n, 2n, 3n]

`distinct_go(xs, seen)` handles a list `xs` that follows elements already
collected in `seen`. It returns the elements of `xs` that are not in `seen` and
not repeated earlier in `xs`, in order. The empty list gives the empty list.

    distinct_go([2n, 1n, 3n, 2n], [1n]) == [2n, 3n]
    distinct_go([1n, 1n], Nil{})        == [1n]

The laws use these prelude names. `P.mem(seen, x)` is `True{}` when `x` occurs
in `seen`. `P.skip_if(b, x, ys)` is `ys` when `b` is `True{}` and `x <> ys`
otherwise. `P.same(n, k)` is a list of `n` copies of `k`.

- `distinct_nil`: `distinct` of the empty list is the empty list.
- `distinct_cons`: `distinct(h <> t)` is `h` in front of `distinct_go(t, h <> Nil{})`.
- `distinct_go_nil`: `distinct_go` of the empty list is the empty list, whatever
  `seen` is.
- `distinct_go_step`: `distinct_go(h <> t, seen)` is `P.skip_if(P.mem(seen, h), h, rest)`,
  where `rest` is `distinct_go(t, h <> seen)`: the head is dropped if it is in
  `seen`, and otherwise kept in front of the walk over `t` with `h` added to
  `seen`.
- `distinct_same_seen`: `distinct_go(P.same(n, k), k <> seen)` is the empty list:
  copies of `k` are all duplicates when `k` has already been seen.
- `distinct_same`: `distinct(k <> P.same(m, k))` is `k <> Nil{}`.
- `distinct_nonadjacent`: `distinct([1n, 2n, 1n])` is `[1n, 2n]`.
