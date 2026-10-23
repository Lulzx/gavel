The reference matches on the list: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.sq_inc(h) <> sq_inc_all(t)`.

- `sq_inc_all_single`: closes by `{==}`; the match steps on the cons cell and
  the tail is `Nil{}`.
- `sq_inc_all_append`: induction on `xs`. `P.append` matches on its first
  argument, so with a variable `xs` nothing reduces. The `Nil{}` case closes by
  `{==}`. In the cons case both sides reduce to `P.sq_inc(h)` consed onto
  something, and the hypothesis at `t` covers the rest:

      %L.sq_inc_all_append(t, ys) : {P.sq_inc(h) <> S.sq_inc_all(P.append(t, ys)) == P.sq_inc(h) <> _ : List<Nat>}
      {==}
