Implement `zip3`, then prove the five laws in `LAWS.bend`.

`zip3(xs, ys, zs)` adds the three lists position by position, `h1 + h2 + h3`
for the three elements at each position, and stops when the shortest list runs
out. Its length is the length of the shortest list. If any list is empty the
answer is the empty list.

    zip3([1n, 2n], [10n, 20n, 30n], [100n]) == [111n]
    zip3([1n, 2n], [3n, 4n], [5n, 6n]) == [9n, 12n]
    zip3(Nil{}, [1n], [1n]) == Nil{}

The laws use two prelude names. `P.len(xs)` is the number of elements of `xs`.
`P.min3(a, b, c)` is the smallest of `a`, `b` and `c`.

- `zip3_nil_left`: an empty first list gives the empty list.
- `zip3_nil_mid`: an empty second list gives the empty list.
- `zip3_nil_right`: an empty third list gives the empty list.
- `zip3_len`: the answer has `P.min3(P.len(xs), P.len(ys), P.len(zs))`
  elements.
- `zip3_cons`: for `h1 <> t1`, `h2 <> t2` and `h3 <> t3`, the answer is
  `h1 + h2 + h3` followed by `zip3(t1, t2, t3)`.
