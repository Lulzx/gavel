Implement `append`, then prove the three laws in `LAWS.bend`.

`append(xs, ys)` is the elements of `xs` followed by the elements of `ys`.

    append([1n, 2n], [3n]) == [1n, 2n, 3n]
    append(Nil{}, [3n])    == [3n]
    append([1n], Nil{})    == [1n]

- `append_nil_left`: appending any list to `Nil{}` on the left gives that list.
- `append_nil`: appending `Nil{}` on the right leaves a list unchanged.
- `append_assoc`: `append` is associative: appending `ys` to `xs` and then `zs`
  gives the same list as appending `zs` to `ys` first and then the result to
  `xs`.
