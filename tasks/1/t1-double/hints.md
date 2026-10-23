The reference matches on the first argument in both targets: `add` answers `b`
for `0n` and `1n + add(p, b)` for `1n+p`, and `double` answers `0n` and
`1n + 1n + double(p)`.

- `add_plus` needs a `Policy.` lemma with the same statement,
  `Policy.add_plus(x, y) : S.add(x, y) == x + y`, proved by induction on `x`
  (rewrite with the hypothesis at `p`, then `{==}`). The law itself is one
  rewrite with it, `%Policy.add_plus(x, y) : {S.add(x, y) == _ : Nat}`, then
  `{==}`.
- `double_succ` closes by `{==}`: `double` steps on `1n+x`.
- `double_eq_add` is an induction on `x`. The `0n` case is `{==}`. In the
  `1n+p` case the goal is `2n + double(p) == 1n + add(p, 1n+p)`, and the
  hypothesis speaks of `add(p, p)`, so it needs a successor lemma:
  `Policy.add_succ_rev(x, y) : 1n + S.add(x, y) == S.add(x, 1n+y)`, itself an
  induction on `x` (its step rewrites with the hypothesis at `p`, hole in
  `1n+_`, goal written with `2n+`). Cite it at `(p, p)`, which uses `p` twice,
  so first rebind `+p = p`. Then rewrite with `L.double_eq_add(p)` and `{==}`.
