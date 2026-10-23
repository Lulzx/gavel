The reference matches on the list: `Nil{}` answers `Nil{}`, and `+h <> t`
answers `(acc + h) <> scan_add(t, acc + h)`: emit the new total and continue from
it. `acc` is `+acc` and `h` is `+h`, since each is used twice.

- `scan_add_nil` and `scan_add_single` close by `{==}`.
- `scan_add_append`: induction on `xs`, with `acc` general because the total
  changes in the step. `Nil{}` is `{==}`. In `h <> t` rewrite with the
  hypothesis at `(t, ys, acc + h)`, then `{==}`. `P.acc_after` threads its
  accumulator the same way `scan_add` does, so no lemma about `+` is needed:

      %L.scan_add_append(t, ys, acc + h) : {(acc + h) <> S.scan_add(P.append(t, ys), acc + h) == (acc + h) <> _ : List<Nat>}
