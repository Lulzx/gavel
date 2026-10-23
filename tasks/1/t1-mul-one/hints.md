The reference matches on the first argument in both targets. `add` answers `b`
for `0n` and `1n + add(p, b)` for `1n+p`. `mul` answers `0n` and
`add(b, mul(p, b))`; `b` is used twice there, so the stub declares `+b`.

- `mul_succ` and `mul_zero` close by `{==}`: `mul` steps on a literal `1n+x` or
  `0n`.
- `add_plus` needs a `Policy.` lemma with the same statement,
  `Policy.add_plus(x, y) : S.add(x, y) == x + y`, an induction on `x` (rewrite
  with the hypothesis at `p`, hole in `1n + _`, then `{==}`). The law is one
  rewrite with it, `%Policy.add_plus(x, y) : {S.add(x, y) == _ : Nat}`, then
  `{==}`.
- `mul_one` is an induction on `x`. The `0n` case is `{==}`. In the `1n+p` case
  the left side reduces to `1n + S.mul(p, 1n)`; rewrite with `L.mul_one(p)`
  (hole in `1n + _`), then `{==}`.
