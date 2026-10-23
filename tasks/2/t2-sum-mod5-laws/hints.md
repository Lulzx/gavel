The reference matches on the list: `Nil{}` gives `0n`, and `h <> t` gives
`P.mod5(h) + sum_mod5(t)`.

- `sum_mod5_nil`: closes by `{==}`.
- `sum_mod5_snoc`: induction on `xs`, using two `Policy.` lemmas about `+`, both
  inductions on their first argument: `{x + 0n == x : Nat}` (`add_zero`) and
  `{a + (b + c) == (a + b) + c : Nat}` (`add_assoc`, with `b` and `c` erased
  as `-b`, `-c` since only the statement uses them).
  - `Nil{}`: both sides are `P.mod5(x)`, the left with a trailing `+ 0n`, so
    rewrite with `add_zero` at `P.mod5(x)` and close by `{==}`.
  - `h <> t`: the hypothesis at `t` has `sum_mod5(P.append(t, x <> Nil{}))` on its
    left, the same side the goal has it on, so flip it with `Equal.sym` before
    rewriting. That leaves `P.mod5(h) + (... + P.mod5(x))` against
    `(P.mod5(h) + ...) + P.mod5(x)`, which `add_assoc` regroups; then `{==}`.
