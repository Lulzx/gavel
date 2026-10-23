The reference matches on the list: `Nil{}` gives `0n`, and `h <> t` gives
`P.sq(h) + sq_sum(t)`.

- `sq_sum_nil`: closes by `{==}`.
- `sq_sum_snoc`: induction on `xs`, using two `Policy.` lemmas about `+`, both
  inductions on their first argument: `{x + 0n == x : Nat}` (`add_zero`) and
  `{a + (b + c) == (a + b) + c : Nat}` (`add_assoc`, with `b` and `c` erased
  as `-b`, `-c` since only the statement uses them).
  - `Nil{}`: both sides are `P.sq(x)`, the left with a trailing `+ 0n`, so
    rewrite with `add_zero` at `P.sq(x)` and close by `{==}`.
  - `h <> t`: the hypothesis at `t` has `sq_sum(P.append(t, x <> Nil{}))` on its
    left, the same side the goal has it on, so flip it with `Equal.sym` before
    rewriting. That leaves `P.sq(h) + (... + P.sq(x))` against
    `(P.sq(h) + ...) + P.sq(x)`, which `add_assoc` regroups; then `{==}`.
