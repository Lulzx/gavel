The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t` answers
`(h + 1n) <> inc_all(t)`.

- `inc_all_single` closes by `{==}`: the cons case steps and the tail is the
  literal `Nil{}`.
- `inc_all_append` is an induction on `xs`, because `P.append` matches on its
  first argument and is stuck on a variable. `Nil{}` is `{==}`. In the cons case
  both sides are `(h + 1n) <>` something, and the hypothesis at `t` supplies the
  something:

      %L.inc_all_append(t, ys) : {(h + 1n) <> S.inc_all(P.append(t, ys)) == (h + 1n) <> _ : List<Nat>}
      {==}
