The reference matches on the list: `Nil{}` is `Nil{}`, and `h <> t` answers
`P.pow2(h) <> pow2_all(t)`.

- `pow2_all_single`: `{==}`; the match steps on the cons and the tail is
  `Nil{}`.
- `pow2_all_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are the mapped head
  consed onto something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.pow2_all_append(t, ys) : {P.pow2(h) <> S.pow2_all(P.append(t, ys)) == P.pow2(h) <> _ : List<Nat>}
