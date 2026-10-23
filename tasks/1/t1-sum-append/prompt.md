Implement `sum` and `append`, then prove the four laws in `LAWS.bend`.

`sum(xs)` is the total of the elements of `xs`; the empty list sums to `0n`.
`append(xs, ys)` is the elements of `xs` followed by the elements of `ys`.

    sum([1n, 2n, 3n])       == 6n
    sum(Nil{})              == 0n
    append([1n, 2n], [3n])  == [1n, 2n, 3n]
    append(Nil{}, [3n])     == [3n]

- `sum_append`: the sum of `append(xs, ys)` is `sum(xs) + sum(ys)`.
- `sum_cons`: `sum(x <> xs)` is `x + sum(xs)`.
- `append_cons`: appending `ys` to a list `h <> t` gives `h` placed in front of
  the result of appending `ys` to `t`.
- `append_nil_left`: `append(Nil{}, ys)` is `ys`.
