The reference matches on `xs`, and in the cons case on `ys`: `Nil{}` answers
`ys`; `hx <> tx` against `Nil{}` answers `hx <> tx`; and `hx <> tx` against
`hy <> ty` answers `hx <> hy <> interleave(tx, ty)`.

- `interleave_nil_l` and `interleave_pair`: both sides compute, so `{==}`.
- `interleave_nil_r`: with a variable `xs` the match is stuck, so match on
  `xs`; both cases then compute and close by `{==}` (no induction needed).
- `interleave_len`: the induction must descend both lists together, so the
  reference proves a `Policy.` copy of the statement,
  `Policy.interleave_len_general(+xs, +ys)`, and the law is one rewrite with it
  and `{==}`. The general lemma matches on `xs`, then on `ys`:
  - `Nil{}`: `{==}`.
  - `hx <> tx` with `Nil{}`: the goal is `1n + P.len(tx) == (1n + P.len(tx)) + 0n`;
    rewrite with a `Policy.` lemma `a == a + 0n` at `P.len(tx)`, then `{==}`.
  - `hx <> tx` with `hy <> ty`: rewrite `P.len(S.interleave(tx, ty))` with the
    hypothesis at `(tx, ty)` (flipped), giving
    `1n + (1n + (P.len(tx) + P.len(ty)))` against
    `(1n + P.len(tx)) + (1n + P.len(ty))`. Rewrite the right side with
    `add_assoc(1n, P.len(tx), 1n + P.len(ty))`
    (`a + (b + c) == (a + b) + c`), then its inner
    `P.len(tx) + (1n + P.len(ty))` with `add_succ_right`
    (`b + (1n + p) == 1n + (b + p)`, flipped), and close by `{==}`.

All three `+` lemmas are inductions on their first argument.
