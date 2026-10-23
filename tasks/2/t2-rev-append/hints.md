The reference matches on `xs`: `Nil{}` answers `ys`, and `h <> t` answers
`rev_append(t, h <> ys)`, carrying the head onto the accumulator.

- `rev_append_single`: `{==}`.
- `rev_append_append`: induction on `xs`, with `ys` and `zs` general because
  the accumulator changes in the step. `Nil{}` is `{==}`. In `h <> t` the goal
  is `rev_append(P.append(t, ys), h <> zs)` against
  `rev_append(ys, rev_append(t, h <> zs))`; rewrite with the hypothesis at
  `(t, ys, h <> zs)` and close with `{==}`:

      %L.rev_append_append(t, ys, h <> zs) : {S.rev_append(P.append(t, ys), h <> zs) == _ : List<Nat>}
