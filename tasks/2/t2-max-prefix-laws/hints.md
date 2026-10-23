The reference matches on `n` first: `0n` answers `0n`, and `1n+k` matches on the
list, answering `0n` on `Nil{}` and `P.max(h, max_prefix(k, t))` on `h <> t`.

- `max_prefix_zero` and `max_prefix_step` close by `{==}`.
- `max_prefix_nil`: the list is a literal but the count is a variable, so
  match on `k`; both cases reduce to `0n`.
- `max_prefix_len`: induction on `xs`. `Nil{}` is `{==}`. In the cons case
  `P.len(h <> t)` is `1n + P.len(t)`, so the count steps too and both sides
  reduce to `P.max` of `h` and a recursive term. Rewrite with the hypothesis at
  `t`, then `{==}`:

      %L.max_prefix_len(t) : {P.max(h, S.max_prefix(P.len(t), t)) == P.max(h, _) : Nat}
