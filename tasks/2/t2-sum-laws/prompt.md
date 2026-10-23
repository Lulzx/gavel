Implement `append` and `sum`, then prove the four laws in `LAWS.bend`.

`append(xs, ys)` is the elements of `xs` followed by the elements of `ys`, in
order. `sum(xs)` is the total of the elements of `xs`, `0n` for the empty list.

    append([1n, 2n], [3n]) == [1n, 2n, 3n]
    append(Nil{}, [3n]) == [3n]
    sum([1n, 2n, 3n]) == 6n
    sum(Nil{}) == 0n

- `sum_append`: the sum of `append(xs, ys)` is the sum of `xs` plus the sum of
  `ys`.
- `sum_single`: the sum of the one-element list `[h]` is `h`.
- `append_cons`: appending `ys` to `h <> t` gives `h` followed by `append(t, ys)`.
- `append_nil_left`: appending `ys` to the empty list gives `ys`.
