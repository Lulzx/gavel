The reference matches on the list: `Nil{}` answers `0n`, and
`P.MkPair{a, b} <> t` answers `P.same(a, b) + count_if(t)`.

- `count_if_nil`, `count_if_cons`: close by `{==}`.
- `count_if_snoc`: induction on `ps`. It needs two `Policy.` lemmas, since `+`
  is stuck on a variable left argument:
  - `add_zero(x)`: `x + 0n == x`, an induction on `x` (rewrite with the
    hypothesis at the predecessor).
  - `add_assoc(a, -b, -c)`: `a + (b + c) == (a + b) + c`, an induction on `a`
    with `b` and `c` erased.

  The `Nil{}` case leaves `P.same(a, b) + 0n` against `P.same(a, b)`; rewrite
  with `add_zero(P.same(a, b))`, goal `{P.same(a, b) + 0n == _ : Nat}`, then
  `{==}`. In the `P.MkPair{c, d} <> t` case the hypothesis at `t` has the
  `count_if(append(t, ...))` on its left, so flip it with `Equal.sym` first,
  goal `{P.same(c, d) + _ == (P.same(c, d) + S.count_if(t)) + P.same(a, b) : Nat}`.
  Then rewrite with `add_assoc(P.same(c, d), S.count_if(t), P.same(a, b))`, goal
  `{P.same(c, d) + (S.count_if(t) + P.same(a, b)) == _ : Nat}`, and `{==}`.
