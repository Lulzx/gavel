The fuel is the first parameter because it is the argument that shrinks:
`Nat.mod(a, b)` is a computed value, not a subterm, so it cannot be the
decreasing argument. The divisor is used twice (as the new `a` and inside the
remainder), so it is declared `+b`.

The reference matches on `fuel`: `0n` answers `a`; `1n++k` matches on `b`, where
`0n` answers `a` and `1n++j` answers `gcd(k, b, Nat.mod(a, b))`.

- `gcd_no_fuel`, `gcd_step` and `gcd_twelve_eighteen` close by `{==}`: the fuel
  is a literal or `1n + f`, `gcd_step`'s divisor is `1n + b` so the inner match
  steps too, and the last is closed.
- `gcd_zero_divisor` is a match on `f` (it never calls itself). The `0n` case
  returns `a`; in the `1n++k` case the inner match on the literal `0n` returns
  `a`. Both are `{==}`.
