The reference matches on `s` and answers `P.snoc(xs, P.Op{})` or
`P.snoc(xs, P.Cl{})`, so `step_op` and `step_cl` are `{==}`.

- `step_len`: match `s`, and in each case use a `Policy` lemma
  `P.len(P.snoc(xs, s)) == 1n + P.len(xs)`, an induction on `xs` whose cons
  case rewrites with the hypothesis under the `1n +`.
- `step_wf`: match `s` and call one lemma at `n = 0n` with both premises:
  `Policy.wf_snoc(xs, n, s, e: {P.wf_go(xs, n) == True{}}, g: {Nat.is_gt(P.depth_go(xs, n), 0n) == True{}})`
  proving `P.wf_go(P.snoc(xs, s), n) == True{}`. It has to be generalised over
  the accumulator `n`, because the scan moves it as it walks the stack. It is
  an induction on `xs`, following `wf_go`'s own cases:
  - `Nil{}`: match `n`. At `0n` the guard has reduced to `{False{} == True{}}`,
    so the goal follows by transport: with a `Policy.bool_ite(b, x)` that is
    `True{}` on `True{}` and `x` on `False{}`,
    `Equal.cong(Bool, Bool, b => Policy.bool_ite(b, x), False{}, True{}, g)`
    proves `x == True{}`. At `1n+p` match `s`; both cases are `{==}`.
  - `P.Op{} <> t`: the hypothesis at `t` and `1n + n`, passing `e` and `g`
    unchanged (their types reduce to the ones at the smaller arguments).
  - `P.Cl{} <> t`: match `n`. At `0n` the premise `e` has reduced to
    `{False{} == True{}}`, so transport again. At `1n+p` the hypothesis at `t`
    and `p`.
