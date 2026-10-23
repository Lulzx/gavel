The reference matches on the list: `Nil{}` is `Nil{}`, and `h <> t` answers
`P.mod3(h) <> mod3_all(t)`.

- `mod3_all_single`: `{==}`; the match steps on the cons and the tail is
  `Nil{}`.
- `mod3_all_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are the mapped head
  consed onto something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.mod3_all_append(t, ys) : {P.mod3(h) <> S.mod3_all(P.append(t, ys)) == P.mod3(h) <> _ : List<Nat>}
