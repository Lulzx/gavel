The reference matches on the list: `Nil{}` gives `0n`, and `h <> t` gives
`P.sq_inc(h) + sum_sq_inc(t)`.

- `sum_sq_inc_nil`: closes by `{==}`.
- `sum_sq_inc_snoc`: induction on `xs`, using two `Policy.` lemmas about `+`, both
  inductions on their first argument: `{x + 0n == x : Nat}` (`add_zero`) and
  `{a + (b + c) == (a + b) + c : Nat}` (`add_assoc`, with `b` and `c` erased
  as `-b`, `-c` since only the statement uses them).
  - `Nil{}`: both sides are `P.sq_inc(x)`, the left with a trailing `+ 0n`, so
    rewrite with `add_zero` at `P.sq_inc(x)` and close by `{==}`.
  - `h <> t`: the hypothesis at `t` has `sum_sq_inc(P.append(t, x <> Nil{}))` on its
    left, the same side the goal has it on, so flip it with `Equal.sym` before
    rewriting. That leaves `P.sq_inc(h) + (... + P.sq_inc(x))` against
    `(P.sq_inc(h) + ...) + P.sq_inc(x)`, which `add_assoc` regroups; then `{==}`.
