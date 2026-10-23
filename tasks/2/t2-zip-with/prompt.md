Implement `zip_with`, then prove the five laws in `LAWS.bend`.

`zip_with(xs, ys)` combines the two lists position by position, taking the
larger of each pair of elements, and stops when the shorter list runs out. Its
length is the length of the shorter list.

    zip_with([1n, 7n], [4n, 2n]) == [4n, 7n]
    zip_with([3n, 9n, 2n], [5n, 1n]) == [5n, 9n]
    zip_with(Nil{}, [1n]) == Nil{}

The laws use three prelude names. `P.max(a, b)` is the larger of `a` and `b`.
`P.len(xs)` is the number of elements of `xs`. `P.min(a, b)` is the smaller of
`a` and `b`.

- `zip_with_nil_left`: an empty first list gives the empty list.
- `zip_with_nil_right`: an empty second list gives the empty list.
- `zip_with_len`: the answer has `P.min(P.len(xs), P.len(ys))` elements.
- `zip_with_self`: combining a list with itself gives the list back.
- `zip_with_cons`: for `h1 <> t1` and `h2 <> t2`, the answer is `P.max(h1, h2)`
  followed by `zip_with(t1, t2)`.
