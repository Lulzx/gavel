The reference matches on the list: `Nil{}` answers `Nil{}`, and `+h <> t`
answers `P.max(m, h) <> run_max(t, P.max(m, h))`: emit the new maximum and
continue from it. `m` is declared `+m` and `h` is bound `+h`, since each is used
twice.

- `run_max_nil` and `run_max_single` close by `{==}`.
- `run_max_append`: induction on `xs`, with `m` general because the running
  value changes in the step. `Nil{}` is `{==}`. In `h <> t` rewrite with the
  hypothesis at `(t, ys, P.max(m, h))`, then `{==}`. `P.after_max` steps the
  same way `run_max` does, so no lemma about `P.max` is needed:

      %L.run_max_append(t, ys, P.max(m, h)) : {P.max(m, h) <> S.run_max(P.append(t, ys), P.max(m, h)) == P.max(m, h) <> _ : List<Nat>}
