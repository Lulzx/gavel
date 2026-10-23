The reference `pred` matches on `n`: `0n` answers `0n` and `1n+p` answers `p`.
`add` matches on `a`: `0n` answers `b` and `1n+p` answers `1n + add(p, b)`, so
it steps on its first argument only.

- `pred_succ` and `pred_zero` close by `{==}`.
- `add_one`: induction on `x`. `0n` is `{==}`. In `1n+p` rewrite with the
  hypothesis at `p`, then `{==}`: `%L.add_one(p) : {1n+S.add(p, 1n) == 1n+_ : Nat}`.
- `add_zero` and `add_succ` are inductions on the first argument (`x`, and `a`
  with `b` fixed), not definitional. Each has `0n` as `{==}` and the successor
  case rewrites with the hypothesis at `p`, then `{==}`. The reference proves
  each as a `Policy.` lemma and has the law call it:
  `%Policy.add_zero(p) : {1n + S.add(p, 0n) == 1n+_ : Nat}` and
  `%Policy.add_succ(p, b) : {1n + S.add(p, 1n+b) == 1n + _ : Nat}`.
