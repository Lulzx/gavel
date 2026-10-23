The reference matches on the list: `Nil{}` answers `Nil{}`, and `+h <> +t`
answers `P.rp_branch(P.eq(h, k), h, y, t, replace_first(t, k, y))`. The
comparison is a computed value, so it goes through the prelude's `P.rp_branch`,
which gives `y <> t` on `True{}` and `h <> r` on `False{}`. `k` and `y` are `+`.

- `replace_first_nil`, `replace_first_three` and `replace_first_absent` close
  by `{==}`.
- `replace_first_hit`: `P.eq(h, h)` is stuck on a variable. A `Policy.` lemma
  `eq_refl(a)`: `{True{} == P.eq(a, a) : Bool}` (oriented with `True{}` on the
  left), by induction on `a`: `0n` is `{==}`, `1n+p` rewrites with the
  hypothesis then `{==}`. Rewrite the decision with it, hole in the first slot
  of `P.rp_branch`, then `{==}`.
- `replace_first_miss`: flip the premise with
  `Equal.sym(Bool, P.eq(a, b), False{}, e)` and rewrite the decision, hole in the
  first slot of `P.rp_branch`; then `{==}`.
- `replace_first_len`: induction on `xs`. `Nil{}` is `{==}`. The cons case uses
  a `Policy.rp_branch_len(b, h, y, t, r, e)` lemma: given
  `e : {P.len(r) == P.len(t)}`, `{P.len(P.rp_branch(b, h, y, t, r)) == 1n + P.len(t)}`,
  by a match on `b` (`True{}` is `{==}`, `False{}` rewrites with `%e`, then
  `{==}`). The law rewrites with it, passing the hypothesis at `t` as `e`, then
  `{==}`.
