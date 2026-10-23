Implement `append` and `len`, then prove the four laws in `LAWS.bend`.

`append(xs, ys)` is the list `xs` followed by the list `ys`. `len(xs)` is the
number of elements of `xs`.

    append([1n, 2n], [3n]) == [1n, 2n, 3n]
    append(Nil{}, [3n]) == [3n]
    len([4n, 4n, 4n]) == 3n
    len(Nil{}) == 0n

The laws use `S.append` and `S.len`, the targets themselves.

- `len_cons`: putting `x` in front of `xs` makes the list one longer,
  `len(x <> xs) == 1n + len(xs)`.
- `len_append`: the length of an append is the sum of the two lengths,
  `len(append(xs, ys)) == len(xs) + len(ys)`.
- `append_cons`: appending to a list that starts with `h` and continues with `t`
  gives `h` in front of `append(t, ys)`.
- `append_nil_left`: appending `ys` to the empty list gives `ys`.
