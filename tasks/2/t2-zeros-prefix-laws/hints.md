The reference matches on `n` first and only then on the list: `0n` gives `0n`,
and `1n+k` gives `0n` on `Nil{}` and `P.is_zero(h) + zeros_prefix(k, t)` on a
cons.

- `zeros_prefix_zero`: closes by `{==}`; the match on `0n` answers `0n` without
  looking at the list.
- `zeros_prefix_len`: induction on `xs`. `P.len` and `P.count_zeros` match on the
  list, so with a variable `xs` neither side reduces. `Nil{}` closes by `{==}`.
  In the cons case the count steps to `1n + P.len(t)`, and both sides reduce to
  `P.is_zero(h)` plus the hypothesis at `t`, so `h` needs no split of its own:

      %L.zeros_prefix_len(t) : {P.is_zero(h) + S.zeros_prefix(P.len(t), t) == P.is_zero(h) + _ : Nat}
      {==}

- `zeros_prefix_nil`: match on `k`; both cases (`0n` and `1n+kp`) close by `{==}`.
- `zeros_prefix_step`: closes by `{==}`; both matches step.
