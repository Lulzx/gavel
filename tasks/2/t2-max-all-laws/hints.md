The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t`
rebinds `+k = n` (it is used twice) and answers `P.max(h, k) <> max_all(t, k)`.

- `max_all_single` closes by `{==}`: the cons case steps and the tail is the
  literal `Nil{}`.
- `max_all_append` is an induction on `xs` with `n` fixed, because `P.append`
  matches on its first argument and is stuck on a variable. `Nil{}` is `{==}`.
  In the cons case both sides are `P.max(h, n) <>` something, and the
  hypothesis at `t` supplies the something:

      %L.max_all_append(t, ys, n) : {P.max(h, n) <> S.max_all(P.append(t, ys), n) == P.max(h, n) <> _ : List<Nat>}
      {==}
