The reference matches on the list: `Nil{}` answers `x <> Nil{}` and `h <> t`
answers `h <> snoc(t, x)`.

- `snoc_nil`: `{==}`.
- `snoc_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are `h` consed onto
  something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.snoc_append(t, ys, x) : {h <> S.snoc(P.append(t, ys), x) == h <> _ : List<Nat>}
