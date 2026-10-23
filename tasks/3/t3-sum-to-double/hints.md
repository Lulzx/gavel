The reference matches on `n`: `0n` answers `0n`, and `1n+p` rebinds `+p = p` and
answers `sum_to(p) + (1n + p)`.

- `sum_to_zero` and `sum_to_succ` close by `{==}`.
- `sum_to_double`: `*` steps on its left argument, so `2n * x` unfolds only to
  `x + (x + 0n)`. The reference proves `Policy.two_mul(x)`: `2n * x == x + x`
  (one rewrite with `add_zero_right`), and the real work as
  `Policy.sum_to_double_add(n)`: `sum_to(n) + sum_to(n) == n * (1n + n)`, an
  induction on `n`. The law is then `+n = n`, a rewrite with `two_mul`, a rewrite
  with `sum_to_double_add`, and `{==}`.

The step of `sum_to_double_add` (with `+p = p`) has
`(sum_to(p) + (1n + p)) + (sum_to(p) + (1n + p))` against
`(1n + p) * (1n + (1n + p))`. The reference rewrites the right side with
`mul_succ_right` twice and `add_assoc` into `((1n + p) + (1n + p)) + (1n + p) * p`,
turns `(1n + p) * p` into `p * (1n + p)` with `mul_comm`, regroups the left side
with `add_assoc` and `add_comm` into
`(sum_to(p) + sum_to(p)) + ((1n + p) + (1n + p))`, rewrites the pair with the
hypothesis, and closes with `add_comm` on the two summands. About a dozen
rewrites in all.

The arithmetic `Policy.` lemmas, each an induction on its first argument:

- `add_zero_right(a)`: `a == a + 0n`.
- `add_assoc(a, -b, -c)`: `a + (b + c) == (a + b) + c`.
- `add_succ_right(a, -b)`: `a + (1n + b) == 1n + (a + b)`.
- `add_comm(a, +b)`: `a + b == b + a`.
- `mul_zero_right(x)`: `x * 0n == 0n`.
- `mul_succ_right(x, +y)`: `x * (1n + y) == x + x * y`.
- `mul_comm(a, +b)`: `a * b == b * a`.
