The reference matches on the list: `Nil{}` answers `0n`, and `h <> t` answers
`P.is_odd(h) + count_odd(t)`.

- `count_odd_nil`: closes by `{==}`.
- `count_odd_snoc`: induction on `xs`, with two `Policy.` lemmas since `+` is
  stuck on a variable left argument:
  - `add_zero(x)`: `x + 0n == x`, an induction on `x`.
  - `add_assoc(a, -b, -c)`: `a + (b + c) == (a + b) + c`, an induction on `a`
    with `b` and `c` erased.

  `Nil{}` case: both sides are `P.is_odd(x)`, the left with a trailing `+ 0n`;
  rewrite with `add_zero(P.is_odd(x))`, goal `{P.is_odd(x) + 0n == _ : Nat}`,
  then `{==}`. Cons case: the hypothesis at `t` has `count_odd(append(t, ...))`
  on its left, so flip it with `Equal.sym`, goal
  `{P.is_odd(h) + _ == (P.is_odd(h) + S.count_odd(t)) + P.is_odd(x) : Nat}`;
  then `add_assoc(P.is_odd(h), S.count_odd(t), P.is_odd(x))`, goal
  `{P.is_odd(h) + (S.count_odd(t) + P.is_odd(x)) == _ : Nat}`; then `{==}`.
