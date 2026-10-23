The reference `add` matches on `a`: `0n` answers `b` and `1n+p` answers
`1n + add(p, b)`. `mul` matches on `a`: `0n` answers `0n` and `1n+p` answers
`add(b, mul(p, b))`. `b` is used twice, so it is declared `+b`.

Every law is an induction on `x`, and the lemmas about `S.add` are all `Policy.`
inductions on their first argument (each: `0n` is `{==}`, successor rewrites
with the hypothesis, then `{==}`):

- `add_plus`: lemma `add_plus(x, y)`: `{S.add(x, y) == x + y : Nat}`; the law
  rewrites with it and closes by `{==}`.
- `add_zero(x)`: `{S.add(x, 0n) == x : Nat}`.
- `add_succ(x, y)`: `{S.add(x, 1n+y) == 1n + S.add(x, y) : Nat}`.
- `add_assoc(x, y, z)`: `{S.add(S.add(x, y), z) == S.add(x, S.add(y, z)) : Nat}`.
- `mul_one_left`: induction on `x`. In `1n+p` the goal leaves `S.add(p, 0n)`;
  rewrite it to `p` with `add_zero(p)` flipped by `Equal.sym`.
- `mul_succ`: do it as a `Policy.mul_succ(+x, +y)` helper (both variables are
  reused) by induction on `x`, then have the law call it. The successor case
  rewrites with the flipped hypothesis, then `add_assoc(y, mul(p, y), p)`, then
  `add_succ` flipped by `Equal.sym`, then `{==}`.
