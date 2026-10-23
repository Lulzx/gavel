The reference matches on the list: `Nil{}` answers `0n`, and a cons answers
`P.rl_step(x, t, nondesc_run(t))`. `P.rl_step` looks at the tail: `1n` if it is
empty, otherwise `P.rl_put(P.le(x, y), n)`, which is `1n + n` on `True{}` and
`1n` on `False{}`. The comparison is a computed value, which is why it lives in
the prelude.

- `nondesc_run_nil` and `nondesc_run_single` close by `{==}`.
- `nondesc_run_up` and `nondesc_run_down`: the goal reduces to
  `P.rl_put(P.le(x, y), ...)`, stuck on the `Bool`. Flip the hypothesis with
  `Equal.sym(Bool, P.le(x, y), True{}, e)` (`False{}` for down) and rewrite
  with the hole at the `Bool` argument, then `{==}`:

      %Equal.sym(Bool, P.le(x, y), True{}, e) : {P.rl_put(_, S.nondesc_run(y <> t)) == 1n + S.nondesc_run(y <> t) : Nat}

- `nondesc_run_le_len`: induction on the tail, as a `Policy.run_le_len_gen(+t, x)`
  that the law calls. It needs a lemma
  `rl_le(+n, +m, k, +e)`: with `e : {P.le(n, m) == True{}}`, gives
  `{P.le(P.rl_put(k, n), 1n + m) == True{} : Bool}`, a match on `k` (`True{}`
  rewrites with `%e`, `False{}` is `{==}`). The generalised helper matches `t`:
  `Nil{}` is `{==}`; in `y <> t2` apply `rl_le` at the run and length of
  `y <> t2` with `P.le(x, y)` and the recursive call as the proof.
