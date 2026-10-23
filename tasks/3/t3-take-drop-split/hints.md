The reference steps on the count first and only then on the list. `take`: `0n`
answers `Nil{}`; `1n+k` answers `Nil{}` on `Nil{}` and `h <> take(k, t)` on a
cons. `drop`: `0n` answers `xs`; `1n+k` answers `Nil{}` on `Nil{}` and
`drop(k, t)` on a cons.

All three laws follow that same shape: match on the count, and in the successor
case match on the list. Each cons case uses the hypothesis at `(k, t)` once.

- `take_drop`: `0n` and `Nil{}` are `{==}`. The cons case is
  `h <> P.append(S.take(k, t), S.drop(k, t)) == h <> t`; rewrite with
  `L.take_drop(k, t)` under `h <> _`, then `{==}`.
- `drop_drop`: `0n` is `{==}` because `0n + m` computes to `m`. In the `1n+k`
  case `(1n + k) + m` computes to `1n + (k + m)`, so `drop` steps on the right.
  - `Nil{}`: the left is `S.drop(m, Nil{})`, stuck on the variable `m`. It needs
    `Policy.drop_nil(m)`: `S.drop(m, Nil{}) == Nil{}`, proved by matching on `m`
    (both cases `{==}`). Rewrite with it flipped, then `{==}`.
  - `h <> t`: the goal is `S.drop(m, S.drop(k, t)) == S.drop(k + m, t)`; rewrite
    with `L.drop_drop(k, m, t)` in the hole on the right, then `{==}`.
- `take_len`: `P.min` steps on its first argument and then its second, in the
  same order as `take`, so `0n` and `Nil{}` are `{==}`, and the cons case is
  `1n + P.len(S.take(k, t)) == 1n + P.min(k, P.len(t))`, closed by the
  hypothesis flipped with `Equal.sym` under `1n + _`.
