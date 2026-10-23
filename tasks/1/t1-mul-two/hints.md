The reference matches on the first argument in both targets. `add` answers `b`
for `0n` and `1n + add(p, b)` for `1n+p`. `mul` answers `0n` and
`add(b, mul(p, b))`; `b` is used twice there, so the stub declares `+b`.

- `mul_zero` and `mul_succ` close by `{==}`: `mul` steps on a literal `0n` or
  `1n+a`.
- `add_zero` is exactly the statement of a `Policy.` lemma,
  `Policy.add_zero(x) : S.add(x, 0n) == x`, an induction on `x` (rewrite with
  the hypothesis at `p`, hole in `1n + _`, then `{==}`); the law's proof is
  just `Policy.add_zero(x)`.
- `mul_two`: `mul(2n, x)` reduces to `S.add(x, S.add(x, 0n))` against
  `x + x`. This needs a second lemma,
  `Policy.add_plus(x, y) : S.add(x, y) == x + y`, also an induction on `x`.
  `x` is used several times, so rebind `+x = x`. Rewrite with
  `Policy.add_plus(x, x)` (goal in `S.add` form, hole where `x + x` sits), then
  with `Policy.add_zero(x)` (hole at the `x` inside the right-hand `S.add(x, _)`)
  to turn that `x` into `S.add(x, 0n)`, then `{==}`.
