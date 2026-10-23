The reference `indexed_go(xs, +i)` matches on the list: `Nil{}` answers `Nil{}`,
and `h <> t` answers `P.MkIndexed{i, h} <> indexed_go(t, i + 1n)`. The list comes
first because it is the shrinking argument; `i` is used twice, hence `+i`.
`indexed(xs)` is `indexed_go(xs, 0n)`.

- `indexed_zero` and `indexed_cons` close by `{==}`.
- `indexed_len` and `indexed_elems` are inductions on `xs`, generalised over
  `i` (the hypothesis is used at `i + 1n`). `Nil{}` is `{==}`. In the cons case
  `P.plen` and `P.elems` step the pair off the front and leave the hypothesis
  at `t`:

      %L.indexed_len(t, i + 1n) : {1n + P.plen(S.indexed_go(t, i + 1n)) == 1n + _ : Nat}
      {==}

  and for `indexed_elems`:

      %L.indexed_elems(t, i + 1n) : {h <> P.elems(S.indexed_go(t, i + 1n)) == h <> _ : List<&2, Nat>}
      {==}
