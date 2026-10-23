The reference matches on `b`: `0n` answers `1n`, and `1n+p` rebinds the base
reusable (`+x = a`) and answers `Nat.mul(x, pow(x, p))`.

- `pow_zero` and `pow_succ` close by `{==}`.
- `pow_one`: `pow(x, 1n)` reduces to `Nat.mul(x, 1n)`, which is stuck on a
  variable `x`. A `Policy.` lemma `mul_one_right(x)`: `{Nat.mul(x, 1n) == x : Nat}`
  by induction on `x` (`1n+p` rewrites with the hypothesis, then `{==}`). The
  law rewrites with it, then `{==}`:

      %Policy.mul_one_right(x) : {Nat.mul(x, 1n) == _ : Nat}
