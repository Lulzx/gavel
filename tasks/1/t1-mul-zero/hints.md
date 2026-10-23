The reference matches on the first argument in both targets. `add` answers `b`
for `0n` and `1n + add(p, b)` for `1n+p`. `mul` answers `0n` and
`add(b, mul(p, b))`; `b` is used twice there, so the stub declares `+b`.

- `mul_zero_left` closes by `{==}`: `mul` steps on a literal `0n`.
- `add_plus` needs a `Policy.` lemma with the same statement,
  `Policy.add_plus(x, y) : S.add(x, y) == x + y`, an induction on `x` (rewrite
  with the hypothesis at `p`, hole in `1n + _`, then `{==}`). The law is one
  rewrite with it, `%Policy.add_plus(x, y) : {S.add(x, y) == _ : Nat}`, then
  `{==}`.
- `mul_zero` is an induction on `x`. The `0n` case is `{==}`. In the `1n+p` case
  the left side reduces to `add(0n, mul(p, 0n))`, which is `S.mul(p, 0n)`;
  rewrite with `L.mul_zero(p)` (goal `S.mul(p, 0n) == _`), then `{==}`.
- `mul_succ_left`: the left side reduces to `S.add(y, S.mul(x, y))` and the
  right is Base's `+`. `y` is used twice, so rebind `+y = y`, then rewrite with
  `Policy.add_plus(y, S.mul(x, y))` (goal in `S.add` form, hole where the Base
  sum sits) and `{==}`.
