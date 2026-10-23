The reference steps on its first argument: `0n` gives `0n`, and `1n+p` gives
`b + mul(p, b)`. The second factor is `+b`, as the stub declares, since it is
used twice in the step.

With a variable right factor nothing reduces, so every law is an induction on
the left factor, and the arithmetic needs `Policy.` facts about `+`, each an
induction on `a`: `a == a + 0n`, `a + (b + c) == (a + b) + c`,
`a + (1n + b) == 1n + (a + b)`, and `a + b == b + a`.

- `mul_one_right`: induction on `x`. The step is `1n + S.mul(p, 1n)`; rewrite
  with the hypothesis flipped by `Equal.sym` (`{1n + _ == 1n + p : Nat}`).
- `mul_zero_right`: induction on `x`; the step is `0n + S.mul(p, 0n)`, rewrite
  with the hypothesis flipped.
- `mul_succ_right`: induction on `x`. Rebind `+p = p` and `+y = y`. The step
  goal is `(1n + y) + S.mul(p, 1n + y) == (1n + p) + (y + S.mul(p, y))`.
  Rewrite with the hypothesis to get `(1n + y) + (p + S.mul(p, y))`, then
  reassociate `y + (p + m)` to `(y + p) + m`, commute `y + p` to `p + y`, and
  reassociate back to `p + (y + m)`; then `{==}`.
- `mul_comm`: induction on `a`. The proof cannot cite the earlier laws from a
  helper, so it carries its own `Policy.mul_zero_right` and
  `Policy.mul_succ_right` (copies of the two laws). In the `0n` case rewrite
  `S.mul(b, 0n)` to `0n`. In the `1n+p` case rebind `+p` and `+b`, rewrite
  `S.mul(p, b)` with the hypothesis `L.mul_comm(p, b)` to get
  `b + S.mul(b, p)`, then rewrite the right side `S.mul(b, 1n + p)` with
  `Policy.mul_succ_right(b, p)` (flipped) and close by `{==}`.
