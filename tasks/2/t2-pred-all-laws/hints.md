The reference matches on the list: `Nil{}` is `Nil{}`, and `h <> t` answers
`P.pred(h) <> pred_all(t)`.

- `pred_all_single`: `{==}`; the match steps on the cons and the tail is
  `Nil{}`.
- `pred_all_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are the mapped head
  consed onto something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.pred_all_append(t, ys) : {P.pred(h) <> S.pred_all(P.append(t, ys)) == P.pred(h) <> _ : List<Nat>}
