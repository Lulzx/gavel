The reference matches on the list: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.triple(h) <> triple_all(t)`.

- `triple_all_single`: closes by `{==}`; the match steps on the cons cell and
  the tail is `Nil{}`.
- `triple_all_append`: induction on `xs`. `P.append` matches on its first
  argument, so with a variable `xs` nothing reduces. The `Nil{}` case closes by
  `{==}`. In the cons case both sides reduce to `P.triple(h)` consed onto
  something, and the hypothesis at `t` covers the rest:

      %L.triple_all_append(t, ys) : {P.triple(h) <> S.triple_all(P.append(t, ys)) == P.triple(h) <> _ : List<Nat>}
      {==}
