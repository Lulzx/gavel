The reference matches on the count: `0n` answers `Nil{}` and `1n+k` answers
`x <> replicate(k, x)`. `x` is declared `+x`.

- `replicate_succ`: `{==}`.
- `replicate_len`: induction on `n`. `0n` is `{==}`. In `1n+p` the goal is
  `1n + P.len(replicate(p, x)) == 1n + p`; rewrite with the hypothesis at `p`,
  then `{==}`:

      %L.replicate_len(p, x) : {1n + P.len(S.replicate(p, x)) == 1n + _ : Nat}
