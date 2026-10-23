Implement `len`, then prove the three laws in `LAWS.bend`.

`len(xs)` is the number of elements of `xs`.

    len([4n, 5n, 6n]) == 3n
    len([9n])         == 1n
    len(Nil{})        == 0n

The laws use `P.append(xs, ys)`, the elements of `xs` followed by those of
`ys`.

- `len_cons`: `len(x <> xs)` is `1n + len(xs)`.
- `len_single`: `len(x <> Nil{})` is `1n`.
- `len_nil_right`: `len(P.append(xs, Nil{}))` equals `len(xs)`, so appending
  `Nil{}` on the right does not change a list's length.
