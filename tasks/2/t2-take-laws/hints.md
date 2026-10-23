The reference matches on `n` first, then on the list: `0n` gives `Nil{}`; `1n+k`
gives `Nil{}` on `Nil{}` and `h <> take(k, t)` on `h <> t`.

- `take_succ`: closes by `{==}`; both matches step.
- `take_append_len`: induction on `xs`. `P.len` and `P.append` both match on the
  list, so with a variable `xs` nothing reduces. `Nil{}` closes by `{==}`. In the
  cons case the count steps to `1n + P.len(t)` and the list to
  `h <> P.append(t, ys)`, so both sides reduce to `h <> ...` around the
  hypothesis at `t`:

      %L.take_append_len(t, ys) : {h <> S.take(P.len(t), P.append(t, ys)) == h <> _ : List<Nat>}
      {==}

- `take_nil`: match on `k`; both cases (`0n` and `1n+kp`) close by `{==}`.
