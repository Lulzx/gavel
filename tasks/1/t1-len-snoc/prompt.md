Implement `len` and `snoc`, then prove the three laws in `LAWS.bend`.

`len(xs)` is the number of elements of `xs`. `snoc(xs, x)` is the elements of
`xs` followed by `x`: the new element goes on the right end, the opposite of a
cons.

    len([4n, 5n, 6n])   == 3n
    len(Nil{})          == 0n
    snoc([1n, 2n], 3n)  == [1n, 2n, 3n]
    snoc(Nil{}, 3n)     == [3n]

- `len_single`: `len(x <> Nil{})` is `1n`.
- `len_snoc`: `len(snoc(xs, x))` is `1n + len(xs)`.
- `snoc_cons`: putting `x` on the right of a list `h <> t` gives `h` placed in
  front of the result of putting `x` on the right of `t`.
