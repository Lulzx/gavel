The reference matches on the count first, then the list: `0n` answers `xs`, and
`1n+k` answers `Nil{}` on `Nil{}` and `drop(k, t)` on `h <> t`.

- `drop_succ` closes by `{==}`: both matches step.
- `drop_append_len` is an induction on `xs`, because `P.len` and `P.append` both
  match on their first argument. `Nil{}` is `{==}`. In the cons case the count
  steps to `1n + P.len(t)` and the list to `h <> P.append(t, ys)`, so the goal
  reduces to `drop(P.len(t), P.append(t, ys)) == ys`, which is the hypothesis:

      %L.drop_append_len(t, ys) : {S.drop(P.len(t), P.append(t, ys)) == _ : List<Nat>}
      {==}
- `drop_nil` matches on `k`: the `0n` case and the `1n+kp` case are both `{==}`
  (the first returns its list, the second hits the inner match on `Nil{}`).
