The reference matches on `n`: `0n` returns `xs`; on `1n+k` it matches `xs`,
answering `x <> pad(k, x, Nil{})` on `Nil{}` and `h <> pad(k, x, t)` on a cons.
`x` is `+` because it is used twice.

- `pad_nil`, `pad_single`, `pad_step`, `pad_nil_step`: each is one branch of
  the body read back, so `{==}`.
- `pad_len`: induction on `n`, then a match on `xs`.
  - `0n`: `{==}`.
  - `1n+k`, `h <> t`: the left is `1n + P.len(S.pad(k, x, t))` and the right
    `P.max(1n + k, 1n + P.len(t))` reduces to `1n + P.max(k, P.len(t))`.
    Rewrite with the hypothesis `L.pad_len(k, x, t)` flipped:
    `{1n + _ == 1n + P.max(k, P.len(t)) : Nat}`, then `{==}`.
  - `1n+k`, `Nil{}`: rebind `+k = k` (it is used twice). The right is `1n + k`.
    Rewrite with the flipped hypothesis `L.pad_len(k, x, Nil{})` to get
    `1n + P.max(k, 0n)`, then with a `Policy.` fact `P.max(a, 0n) == a`
    (flipped), then `{==}`. That fact is a match on `a` with both cases `{==}`,
    not an induction: `P.max(1n + p, 0n)` computes to `1n + p`.
