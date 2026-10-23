The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t`
rebinds `+h2 = h` (the head is used twice) and answers
`(h2 + h2) <> double_all(t)`.

- `double_all_single` closes by `{==}`: the cons case steps and the tail is the
  literal `Nil{}`.
- `double_all_append` is an induction on `xs`, because `P.append` matches on its
  first argument and is stuck on a variable. `Nil{}` is `{==}`. In the cons case
  both sides are `(h + h) <>` something, and the hypothesis at `t` supplies the
  something:

      %L.double_all_append(t, ys) : {(h + h) <> S.double_all(P.append(t, ys)) == (h + h) <> _ : List<Nat>}
      {==}
