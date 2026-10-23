The reference matches on both arguments at once: `0n 0n` answers `0n`,
`0n 1n+bp` answers `0n`, `1n+ap 0n` answers `1n+ap`, and `1n+ap 1n+bp` answers
`sub(ap, bp)`.

- `sub_saturates` is a match on `y` with `{==}` in both cases (`0n` and
  `1n+yp` each pick a branch that answers `0n`).
- `sub_cancel` is an induction on `x`. In the `1n+p` case both `+` and `sub`
  step, leaving `S.sub(p + y, p) == y`; rewrite with `L.sub_cancel(p, y)`
  (goal `S.sub(p + y, p) == _`), then `{==}`. The `0n` case reduces to
  `S.sub(y, 0n) == y` with `y` a variable, so it needs a `Policy.` lemma,
  `Policy.sub_zero_right(x) : S.sub(x, 0n) == x`, proved by a match on `x`
  with `{==}` in both cases. Rewrite with `Policy.sub_zero_right(y)` (goal
  `S.sub(y, 0n) == _`), then `{==}`.
