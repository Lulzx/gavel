The reference matches on the count: `0n` answers `Nil{}`, and `1n+j` answers
`a <> enum_from(j, 1n + a)`. The start is used twice, so it is declared `+a`.

- `enum_from_zero` and `enum_from_succ` close by `{==}`: the match on the count
  steps.
- `enum_from_len` is an induction on `n`, generalised over the start (the
  hypothesis is used at `1n + a`). `0n` is `{==}`. In the `1n+j` case the goal
  reduces to `1n + P.len(enum_from(j, 1n + a)) == 1n + j`:

      %L.enum_from_len(j, 1n + a) : {1n + P.len(S.enum_from(j, 1n + a)) == 1n + _ : Nat}
      {==}
