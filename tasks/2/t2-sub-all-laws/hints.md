The reference matches on the list: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.sub(h, k) <> sub_all(t, k)`. The cons case uses `n` twice, so it rebinds it
first with `+k = n`.

- `sub_all_single`: closes by `{==}`; the match steps on the cons cell and the
  tail is `Nil{}`.
- `sub_all_append`: induction on `xs`. `P.append` matches on its first
  argument, so with a variable `xs` nothing reduces. The `Nil{}` case closes by
  `{==}`. In the cons case both sides reduce to `P.sub(h, n)` consed onto
  something, and the hypothesis at `t` (same `ys`, same `n`) covers the rest:

      %L.sub_all_append(t, ys, n) : {P.sub(h, n) <> S.sub_all(P.append(t, ys), n) == P.sub(h, n) <> _ : List<Nat>}
      {==}
