The reference matches on `a`: `0n` answers `0n` and `1n+p` answers
`b + mul(p, b)`. `b` is used twice, so it is declared `+b`.

Both laws are inductions on the left number, and need two `Policy.` lemmas:

- `add_zero_right(x)`: `{x == x + 0n : Nat}`, induction on `x`.
- `add_reassoc(a, b, c)`: `{(a + b) + c == a + (b + c) : Nat}`, induction on `a`.

`mul_one_left`: match on `x`. `0n` is `{==}`. In `1n+p` the goal leaves
`1n + (p + 0n)`; rewrite with `add_zero_right(p)`
(`{1n + _ == 1n + p : Nat}`), then `{==}`.

`mul_distrib`: match on `x` (that is what `x + y` steps on). `0n` is `{==}`. In
`1n+p` the goal is `z + mul(p + y, z)` against
`(z + mul(p, z)) + mul(y, z)`. Rebind `+p = p`, `+y = y`, `+z = z` since they
are used again. Rewrite the hypothesis `L.mul_distrib(p, y, z)` flipped with
`Equal.sym`, then `add_reassoc(z, mul(p, z), mul(y, z))`, then `{==}`.
