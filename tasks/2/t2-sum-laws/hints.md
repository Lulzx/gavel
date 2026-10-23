The reference matches on the list in both: `append` gives `ys` on `Nil{}` and
`h <> append(t, ys)` on `h <> t`; `sum` gives `0n` on `Nil{}` and `h + sum(t)`
on `h <> t`.

`append_cons` and `append_nil_left` close by `{==}`.

Two `Policy.` lemmas about `+`, both inductions on their first argument:
`{x + 0n == x : Nat}` (`add_zero`) and `{a + (b + c) == (a + b) + c : Nat}`
(`add_assoc`, with `b` and `c` erased as `-b`, `-c`).

- `sum_single`: the left side reduces to `h + 0n`; rewrite with `add_zero` at
  `h`, then `{==}`.
- `sum_append`: induction on `xs`. `Nil{}` closes by `{==}`. In the cons case the
  left side is `h + sum(append(t, ys))`. Flip the hypothesis at `t` with
  `Equal.sym` and rewrite `sum(append(t, ys))` into `sum(t) + sum(ys)`, then
  regroup with `add_assoc` at `(h, sum(t), sum(ys))`, then `{==}`.
