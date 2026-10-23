Implement `len` and `append`, then prove the five laws in `LAWS.bend`.

`len(xs)` is the number of elements of `xs`. `append(xs, ys)` is the elements of
`xs` followed by the elements of `ys`.

    len([4n, 5n, 6n])        == 3n
    len(Nil{})               == 0n
    append([1n, 2n], [3n])   == [1n, 2n, 3n]
    append(Nil{}, [3n])      == [3n]

- `len_cons`: `len(x <> xs)` is `1n + len(xs)`.
- `len_single`: `len(x <> Nil{})` is `1n`.
- `len_nil_right`: appending `Nil{}` on the right does not change a list's
  length.
- `append_nil_left`: `append(Nil{}, ys)` is `ys`.
- `append_cons`: appending `ys` to a list `h <> t` gives `h` placed in front of
  the result of appending `ys` to `t`.
