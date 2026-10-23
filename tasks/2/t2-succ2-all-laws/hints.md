The reference matches on the list: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.succ2(h) <> succ2_all(t)`.

- `succ2_all_single`: closes by `{==}`; the match steps on the cons cell and
  the tail is `Nil{}`.
- `succ2_all_append`: induction on `xs`. `P.append` matches on its first
  argument, so with a variable `xs` nothing reduces. The `Nil{}` case closes by
  `{==}`. In the cons case both sides reduce to `P.succ2(h)` consed onto
  something, and the hypothesis at `t` covers the rest:

      %L.succ2_all_append(t, ys) : {P.succ2(h) <> S.succ2_all(P.append(t, ys)) == P.succ2(h) <> _ : List<Nat>}
      {==}
