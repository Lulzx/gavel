The reference matches on `n`, and in the successor case on the list. `0n`
answers `xs`. `1n+p` answers `Nil{}` for `Nil{}`, and for `h <> t` answers
`rotate(p, P.append(t, h <> Nil{}))`. `xs` is read in both the `0n` branch and
the successor branch, so the stub declares `+xs`.

- `rotate_zero` and `rotate_succ` close by `{==}`: the count is a literal
  (`0n`, `1n + n`), and for `rotate_succ` so is the cons, so both matches step
  and both sides are the same recursive call.
- `rotate_nil` is a match on `n` with no hypothesis: the `0n` case and the
  `1n+p` case each reduce to `Nil{}`, so each is `{==}`.
