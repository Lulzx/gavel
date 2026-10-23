The reference matches on `xs`, then on the tail. `Nil{}` answers `Nil{}`, a
one-element list answers `h <> Nil{}`, and `h <> (h2 <> t2)` answers
`h <> (sep <> intersperse(t, sep))` with `t` the whole tail. `sep` is used
twice (emitted, then passed on), so the stub declares `+sep`.

- `intersperse_nil`, `intersperse_single` and `intersperse_cons` close by
  `{==}`: the lists are literal constructors, so both matches step.
- `intersperse_len` is an induction on `xs` with a second match on the tail,
  because `P.ilen` has its own case for the one-element list. `Nil{}`: both
  sides are `0n`. `h <> Nil{}`: both sides are `1n`, by `{==}`. `h <> (h2 <>
  t2)`: `P.len` steps off the first cons and the answer's length is `2n` plus
  `P.len(S.intersperse(h2 <> t2, sep))`; rewrite with the hypothesis at the
  smaller list, `L.intersperse_len(h2 <> t2, sep)` (hole in `2n + _`), then
  `{==}`.
