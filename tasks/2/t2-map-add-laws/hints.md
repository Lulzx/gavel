The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t`
rebinds `+k = n` (it is used twice) and answers `(h + k) <> map_add(t, k)`.

- `map_add_single` closes by `{==}`: the cons case steps and the tail is the
  literal `Nil{}`.
- `map_add_append` is an induction on `xs` with `n` fixed, because `P.append`
  matches on its first argument and is stuck on a variable. `Nil{}` is `{==}`.
  In the cons case both sides are `(h + n) <>` something, and the hypothesis at
  `t` supplies the something:

      %L.map_add_append(t, ys, n) : {(h + n) <> S.map_add(P.append(t, ys), n) == (h + n) <> _ : List<Nat>}
      {==}
