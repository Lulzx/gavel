The reference matches on the list, then on its tail: `Nil{}` answers `Nil{}`;
`x <> Nil{}` answers `Nil{}`; and `x <> (h <> t2)` answers
`P.MkPair{x, h} <> pairs(h <> t2)`. The recursion is on the tail starting at
the second element, not on `t2`.

- `pairs_nil`, `pairs_single` and `pairs_cons` close by `{==}`.
- `pairs_len`: induction on `xs`, with `x` left general because the hypothesis
  is used at the new front `h`. `Nil{}` is `{==}`. In `h <> t` the goal is
  `1n + P.plen(pairs(h <> t)) == 1n + P.len(t)`; rewrite with the hypothesis at
  `(t, h)`, then `{==}`:

      %L.pairs_len(t, h) : {1n + P.plen(S.pairs(h <> t)) == 1n + _ : Nat}
