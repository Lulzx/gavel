The reference matches on the list: `Nil{}` is `Nil{}`, and `h <> t` answers
`P.min(h, k) <> min_all(t, k)`. `n` is used twice in the step, so it is
rebound reusable first with `+k = n`.

- `min_all_single`: `{==}`; the match steps on the cons and the tail is `Nil{}`.
- `min_all_append`: induction on `xs`, since `P.append` matches on its first
  argument. `Nil{}` is `{==}`. In the cons case both sides are the capped head
  consed onto something; rewrite with the hypothesis at `t`, then `{==}`:

      %L.min_all_append(t, ys, n) : {P.min(h, n) <> S.min_all(P.append(t, ys), n) == P.min(h, n) <> _ : List<Nat>}
