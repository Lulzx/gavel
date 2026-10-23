The reference matches on both arguments at once: any case with a `0n` answers
`0n`, and `1n+ap 1n+bp` answers `1n+min(ap, bp)`.

- `min_self`: induction on `x`. `0n` is `{==}`. In `1n+p` the call unfolds to
  `1n+min(p, p)`; rewrite with the hypothesis at `p`, then `{==}`:
  `%L.min_self(p) : {1n+S.min(p, p) == 1n+_ : Nat}`.
- `min_comm`: match on `x`, and inside each case on `y`. The three cases with a
  zero are `{==}`. In `1n+p` / `1n+q` rewrite with `L.min_comm(p, q)` and close
  with `{==}`.
- `min_zero_left`: not definitional with `y` a variable, so match on `y`; both
  cases are `{==}`.
- `min_succ_succ`: `{==}`.
