The reference matches on `n` first and only then on the list: `0n` answers `0n`,
and a successor `1n+k` answers `0n` on `Nil{}` and
`P.is_odd(h) + count_odd_prefix(k, t)` on a cons.

- `count_odd_prefix_zero`: the match on `0n` answers `0n` without looking at
  the list; `{==}`.
- `count_odd_prefix_step`: both matches step; `{==}`.
- `count_odd_prefix_nil`: the list is a literal but the count is a variable, so
  match on `k`; both cases close by `{==}`.
- `count_odd_prefix_len`: induction on `xs`, since `P.len` and `P.count_odd` are
  stuck on a variable list. The `Nil{}` case is `{==}`. In the cons case the
  count steps too (`P.len(h <> t)` is `1n + P.len(t)`), and both sides reduce to
  `P.is_odd(h)` plus the hypothesis at `t`:

      %L.count_odd_prefix_len(t) : {P.is_odd(h) + S.count_odd_prefix(P.len(t), t) == P.is_odd(h) + _ : Nat}
      {==}
