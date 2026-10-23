Implement `replace_at`, then prove the four laws in `LAWS.bend`.

`replace_at(n, xs, y)` is `xs` with the element at position `n` replaced by `y`,
counting positions from `0n` at the front. When `n` is past the last position,
the result is `xs` unchanged. The empty list gives `Nil{}`.

    replace_at(1n, [4n, 5n, 6n], 9n) == [4n, 9n, 6n]
    replace_at(0n, [4n, 5n], 9n) == [9n, 5n]
    replace_at(5n, [4n, 5n], 9n) == [4n, 5n]
    replace_at(2n, Nil{}, 9n) == Nil{}

- `replace_at_nil`: on the empty list the answer is `Nil{}`, whatever `n` and
  `y` are.
- `replace_at_zero`: `replace_at(0n, h <> t, y)` is `y <> t`.
- `replace_at_succ`: `replace_at(1n + n, h <> t, y)` is `h <> replace_at(n, t, y)`.
- `replace_at_idem`: replacing position `n` with `y` and then with `z` is
  replacing it with `z`: `replace_at(n, replace_at(n, xs, y), z)` is
  `replace_at(n, xs, z)`.
