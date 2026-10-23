The reference matches on the list: `Nil{}` gives `0n`, and `h <> t` gives
`P.pow2(h) + sum_pow2(t)`.

- `sum_pow2_nil`: closes by `{==}`.
- `sum_pow2_snoc`: induction on `xs`, using two `Policy.` lemmas about `+`, both
  inductions on their first argument: `{x + 0n == x : Nat}` (`add_zero`) and
  `{a + (b + c) == (a + b) + c : Nat}` (`add_assoc`, with `b` and `c` erased
  as `-b`, `-c` since only the statement uses them).
  - `Nil{}`: both sides are `P.pow2(x)`, the left with a trailing `+ 0n`, so
    rewrite with `add_zero` at `P.pow2(x)` and close by `{==}`.
  - `h <> t`: the hypothesis at `t` has `sum_pow2(P.append(t, x <> Nil{}))` on its
    left, the same side the goal has it on, so flip it with `Equal.sym` before
    rewriting. That leaves `P.pow2(h) + (... + P.pow2(x))` against
    `(P.pow2(h) + ...) + P.pow2(x)`, which `add_assoc` regroups; then `{==}`.
