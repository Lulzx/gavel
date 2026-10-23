Implement `replace_first`, then prove the six laws in `LAWS.bend`.

`replace_first(xs, k, y)` is `xs` with the first occurrence of `k` replaced by
`y`. Later occurrences of `k` are left alone, and when `k` does not occur the
list is unchanged. The lists are `List<&2, Nat>`.

    replace_first([1n, 2n, 1n], 1n, 9n) == [9n, 2n, 1n]
    replace_first([1n, 2n, 3n], 5n, 9n) == [1n, 2n, 3n]
    replace_first(Nil{}, 4n, 9n) == Nil{}

The laws use `P.eq(a, b)`, the `Bool` that says `a` equals `b`, and `P.len(xs)`,
the number of elements of `xs`.

- `replace_first_nil`: on the empty list the answer is `Nil{}`, whatever `k` and
  `y` are.
- `replace_first_hit`: when the head is `k`, `replace_first(h <> t, h, y)` is
  `y <> t`.
- `replace_first_miss`: when `P.eq(a, b) == False{}`, `replace_first(a <> t, b, y)`
  is `a <> replace_first(t, b, y)`.
- `replace_first_len`: the result has the same length as `xs`.
- `replace_first_three`: `replace_first([1n, 2n, 1n], 1n, 9n)` is `[9n, 2n, 1n]`.
- `replace_first_absent`: `replace_first([1n, 2n, 3n], 5n, 9n)` is `[1n, 2n, 3n]`.
