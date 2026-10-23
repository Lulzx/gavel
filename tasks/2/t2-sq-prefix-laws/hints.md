The reference matches on `n` first and only then on the list: `0n` answers
`0n`, and a successor `1n+k` answers `0n` on `Nil{}` and `P.sq(h) +
sq_prefix(k, t)` on a cons.

- `sq_prefix_zero`: closes by `{==}`; the match on `0n` answers `0n` without
  looking at the list.
- `sq_prefix_len`: induction on `xs`. `P.len` and `P.sq_sum` match on the list,
  so with a variable `xs` neither side reduces. `Nil{}` closes by `{==}`. In the
  cons case `P.len(h <> t)` is `1n + P.len(t)`, so the count steps too, and both
  sides reduce to `P.sq(h)` plus the hypothesis at `t`:

      %L.sq_prefix_len(t) : {P.sq(h) + S.sq_prefix(P.len(t), t) == P.sq(h) + _ : Nat}
      {==}

- `sq_prefix_nil`: match on `k`; both cases (`0n` and `1n+kp`) close by `{==}`.
- `sq_prefix_step`: closes by `{==}`; both matches step.
