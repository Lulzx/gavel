The reference matches on `xss`, then on its tail: `Nil{}` answers `Nil{}`;
`h <> t` with `t` being `Nil{}` answers `h`; `h <> t` with `t` being `h2 <> t2`
answers `P.append(h, P.append(sep, intercalate(sep, h2 <> t2)))`. The separator
is used twice, so it is declared `+sep`.

- `intercalate_nil`, `intercalate_single` and `intercalate_cons` close by
  `{==}`: each argument is a constructor shape the matches step on.
- `intercalate_nil_sep` is an induction on `xss` with a split on the tail,
  and needs `Policy.append_nil(xs) : xs == P.append(xs, Nil{})` (induction on
  `xs`; the cons case rewrites with `append_nil(t)` under `h <>`).
  - `Nil{}`: `{==}`.
  - `h <> Nil{}`: the left is `h`, the right is `P.append(h, Nil{})`; rewrite
    with `append_nil(h)` then `{==}`.
  - `h <> (h2 <> t2)`: `P.append(Nil{}, ...)` reduces away; flip the hypothesis
    with `Equal.sym(List<&2, Nat>, S.intercalate(Nil{}, h2 <> t2), P.concat(h2 <> t2), L.intercalate_nil_sep(h2 <> t2))`,
    rewrite into the hole of `P.append(h, _) == P.append(h, P.concat(h2 <> t2))`,
    then `{==}`.
