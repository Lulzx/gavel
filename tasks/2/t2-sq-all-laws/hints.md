The reference matches on the list: `Nil{}` is `Nil{}`, and `h <> t` answers
`P.sq(h) <> sq_all(t)`.

- `sq_all_single`: `{==}`; the match steps on the cons and the tail is `Nil{}`.
- `sq_all_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are the squared head
  consed onto something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.sq_all_append(t, ys) : {P.sq(h) <> S.sq_all(P.append(t, ys)) == P.sq(h) <> _ : List<Nat>}
