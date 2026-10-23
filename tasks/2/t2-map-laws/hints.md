The reference matches on the list in both defs. `len`: `Nil{}` answers `0n`, and
`h <> t` answers `1n + len(t)`. `map`: `Nil{}` answers `Nil{}`, and `h <> t`
answers `(1n + h) <> map(t)`.

- `map_cons` and `len_single` close by `{==}`.
- `len_map_cons` needs `Policy.len_map(xs) : len(map(xs)) == len(xs)`, an
  induction on `xs`: `Nil{}` is `{==}`, and the cons case rewrites with
  `Policy.len_map(t)` under `1n +`, then `{==}`. The law itself is one rewrite
  with that lemma, since `map(h <> t)` steps to `(1n + h) <> map(t)` and `len`
  of that is `1n + len(map(t))`:

      %Policy.len_map(t) : {1n+S.len(S.map(t)) == 1n+_ : Nat}
      {==}
