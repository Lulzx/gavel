The reference matches on the list first and then, in the cons case, on the
count: `Nil{}` answers `0n`; `h <> t` answers `h` at `0n` and `at(t, k)` at
`1n+k`.

- `at_succ` and `at_nil`: close by `{==}`; `at_succ` has a cons list and a
  successor count, so both matches step.
- `at_len_append`: induction on `xs`. The `Nil{}` case closes by `{==}`. In the
  cons case both matches step and the goal is the hypothesis at `t`, so rewrite
  with it, goal `{S.at(P.append(t, y <> Nil{}), P.len(t)) == _ : Nat}`, then
  `{==}`.
